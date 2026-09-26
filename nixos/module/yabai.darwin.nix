# Mac の Spaces を指定した順序にするツール
{ pkgs, lib, ... }:
let
  # 各スロットの定義
  # スロットとはウィンドーを差しこむべきスペースの位置と定義する。
  # [{
  #   label :: string;       # スペースに付けるラベル
  #   app   :: regex | null; # 全画面化するアプリの名前、null ならデスクトップ
  #   title :: regex | null; # ウィンドウタイトルの条件（先頭 ! で否定）、null なら無条件でマッチ
  #   multi :: boolean;      # このスロットに複数のスペース（フルスクリーンウィンドー）を並べられるか
  # }]
  slots = [
    {
      label = "desktop-private";
      app = null;
      title = null;
      multi = false;
    }
    {
      label = "firefox";
      app = "^Firefox$";
      title = null;
      multi = true;
    }
    {
      label = "claude";
      app = "^Claude$";
      title = null;
      multi = true;
    }
    {
      label = "terminal-private";
      app = "^ターミナル$";
      title = null;
      multi = false;
    }
    {
      label = "vscode-private";
      app = "^Code$";
      title = "!— Herp$";
      multi = true;
    }
    {
      label = "desktop-herp";
      app = null;
      title = null;
      multi = false;
    }
    {
      label = "slack";
      app = "^Slack$";
      title = null;
      multi = true;
    }
    {
      label = "chrome";
      app = "^Google Chrome$";
      title = null;
      multi = true;
    }
    {
      label = "cursor";
      app = "^Cursor$";
      title = null;
      multi = true;
    }
    {
      label = "terminal-herp";
      app = "^ターミナル$";
      title = null;
      multi = false;
    }
    {
      label = "vscode-herp";
      app = "^Code$";
      title = "— Herp$";
      multi = true;
    }
  ];

  watchedApps = lib.unique (lib.map (s: s.app) (lib.filter (s: s.app != null) slots));

  assignSpace = pkgs.writeShellApplication {
    name = "yabai-assign-space";
    runtimeInputs = [
      pkgs.yabai
      pkgs.jq
      pkgs.util-linux
    ];
    text = ''
      # $YABAI_WINDOW_ID は yabai の提供する変数
      window_id="''${YABAI_WINDOW_ID:?}"

      # launchd 経由だと標準出力・標準エラー出力がどこにも残らないので、
      # 自前でログファイルに追記する
      log_file="$HOME/Library/Logs/yabai-assign-space.log"
      mkdir -p "$(dirname "$log_file")"
      exec >> "$log_file" 2>&1
      echo "===== $(date '+%Y-%m-%d %H:%M:%S') pid=$$ window_id=$window_id ====="

      # 連想配列は順序を持たないので、並び順だけは別の配列で持つ
      order=(${lib.concatMapStringsSep "\n        " (s: ''"${s.label}"'') slots})
      # マップ（ラベル → app）
      declare -A apps=(
        ${lib.concatMapStringsSep "\n        " (
          s: ''[${s.label}]="${s.app}"''
        ) (builtins.filter (s: s.app != null) slots)}
      )
      # マップ（ラベル → title）
      declare -A titles=(
        ${lib.concatMapStringsSep "\n        " (
          s: ''[${s.label}]="${s.title}"''
        ) (builtins.filter (s: s.title != null) slots)}
      )
      # マップ（ラベル → multi。true ならこのスロットに複数のスペースを並べて持てる）
      declare -A multi=(
        ${lib.concatMapStringsSep "\n        " (
          s: ''[${s.label}]="${lib.boolToString s.multi}"''
        ) (builtins.filter (s: s.app != null) slots)}
      )

      # 排他ロック
      # 二重起動しないように
      exec 9>/tmp/yabai-assign-space.lock
      flock 9

      # 今起動しようとしているウィンドーの情報を取得する
      win_json=$(yabai -m query --windows --window "$window_id")
      app=$(jq -r '.app' <<< "$win_json")
      title=$(jq -r '.title' <<< "$win_json")
      echo "app=[$app] title=[$title]"

      # このツールで操作しないウィンドーは無視する
      # つまり float で開く
      match=false
      for pattern in "''${apps[@]}"; do
        [[ "$app" =~ $pattern ]] && match=true
      done
      if [ "$match" = "false" ]
      then
        echo "対象アプリでは無いので何もしない"
        exit 0
      fi

      # 今開いているスペースのラベルを取得する（リスト）
      mapfile -t existing_labels < <(yabai -m query --spaces | jq -r '.[].label | select(length > 0)')

      exists() {
        local needle="$1"
        local -n haystack="$2"
        for l in "''${haystack[@]}"; do
          [ "$l" = "$needle" ] && return 0
        done
        return 1
      }

      matches() {
        local target="$1"
        local pattern="$2"
        [ -z "$pattern" ] && return 0
        if [[ "$pattern" == "!"* ]]
        then
          [[ ! "$target" =~ ''${pattern:1} ]]
        else
          [[ "$target" =~ $pattern ]]
        fi
      }

      # 今開いたウィンドーが入るスロットを決める。
      slot_index=0
      for ((slot_index = 0; slot_index < ''${#order[@]}; slot_index++))
      do
        label="''${order[$slot_index]}"
        matches "$app" "''${apps[$label]:-}" || continue
        matches "$title" "''${titles[$label]:-}" || continue
        ! exists "$label" existing_labels || [ "''${multi[$label]:-false}" = "true" ] && break
      done
      # 配置すべきスロットがなかった場合は float のまま何もしない
      if [ "$slot_index" -ge "''${#order[@]}" ]
      then
        echo "空いている（か multi な）スロットが無いので float のまま"
        exit 0
      fi
      current_slot_label="''${order[$slot_index]}"
      echo "マッチしたスロット: $current_slot_label"

      # このスロットに既にいくつスペースがあるかを数え、割り当てるラベルを決める。
      # 1枚目はスロットのラベルそのまま、2枚目以降は -2, -3, ... を付けて区別する
      assign_label="$current_slot_label"
      n=1
      for l in "''${existing_labels[@]}"
      do
        if [ "$l" = "$current_slot_label" ] || [[ "$l" =~ ^''${current_slot_label}-[0-9]+$ ]]
        then
          n=$((n + 1))
        fi
      done
      [ "$n" -gt 1 ] && assign_label="''${current_slot_label}-''${n}"
      echo "割り当てラベル: $assign_label (このスロットの既存メンバー数: $((n - 1)))"

      # 自分より後ろのスロットを順に見て、今すでに実在する
      # 最初のものの直前に挿入する
      insert_before_slot_label=last
      for ((j = slot_index + 1; j < ''${#order[@]}; j++))
      do
        candidate="''${order[$j]}"
        if exists "$candidate" existing_labels
        then
          insert_before_slot_label="$candidate"
          break
        fi
      done
      echo "移動先（この直前に挿入）: $insert_before_slot_label"

      echo "--toggle native-fullscreen を実行"
      yabai -m window "$window_id" --toggle native-fullscreen

      # ネイティブフルスクリーン化（新しいスペースの生成）は非同期なので、反映されるまで最大3秒ポーリングで待つ
      is_fs=""
      space_index=""
      for _ in $(seq 1 30)
      do
        sleep 0.1
        space_index=$(yabai -m query --windows --window "$window_id" | jq -r '.space')
        is_fs=$(yabai -m query --spaces --space "$space_index" | jq -r '.["is-native-fullscreen"]')
        [ "$is_fs" = "true" ] && break
        is_fs=""
      done

      if [ "$is_fs" != "true" ]
      then
        echo "エラー: ネイティブフルスクリーン化を確認できなかった (space_index=$space_index)"
        exit 1
      fi
      echo "フルスクリーン確認: space_index=$space_index"

      # ラベルを付ける
      echo "ラベル付け: space $space_index -> $assign_label"
      yabai -m space "$space_index" --label "$assign_label"

      # ウィンドー（スペース）を移動する
      echo "移動: $assign_label -> $insert_before_slot_label の直前"
      yabai -m space "$assign_label" --move "$insert_before_slot_label"
      echo "完了"
    '';
  };
in
{
  services.yabai = {
    enable = true;

    # スペースの並び替え（--move）に SIP の部分的な無効化が必要
    # https://github.com/asmvik/yabai/wiki/Disabling-System-Integrity-Protection
    enableScriptingAddition = true;

    config = {
      layout = "float";
    };

    extraConfig = ''
      yabai -m space 1 --label desktop-private
      yabai -m space 2 --label desktop-herp

      ${lib.concatMapStringsSep "\n" (
        app: ''yabai -m signal --add event=window_created app="${app}" action="${assignSpace}/bin/yabai-assign-space"''
      ) watchedApps}
    '';
  };
}
