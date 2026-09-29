package main

import (
	"context"
	"fmt"
	"log"
	"os"
	"time"

	ifc "github.com/kakkun61/go-international-fixed-calendar"
	"github.com/mattn/go-mastodon"
)

const (
	SERVER = "https://ap.kakkun61.com"
)

func main() {
	accessToken := os.Getenv("ACCESS_TOKEN")
	if accessToken == "" {
		log.Fatal("ACCESS_TOKEN is not set")
	}

	client := mastodon.NewClient(&mastodon.Config{
		Server:      SERVER,
		AccessToken: accessToken,
	})

	// 現在月日を取得
	jst, err := time.LoadLocation("Asia/Tokyo")
	if err != nil {
		log.Fatalf("failed to load location: %v", err)
	}
	now := ifc.FromGregorian(time.Now().In(jst))
	month, day := now.Month(), now.Day()
	weekday := now.Weekday()
	var message string
	switch day {
	case ifc.LeapDay:
		message = "今日はうるう日です。"
	case ifc.YearDay:
		message = "今日は大みそかです。"
	default:
		message = fmt.Sprintf("今日は %d 月 %d 日で%sです。", month, day, weekdayString(weekday))
	}

	// 公開範囲と言語は指定しなければアカウントの既定値が使われる
	status, err := client.PostStatus(context.Background(), &mastodon.Toot{
		Status: message,
	})
	if err != nil {
		log.Fatalf("failed to create post: %v", err)
	}

	log.Printf("Post created successfully: %s", status.URL)
}

func weekdayString(w time.Weekday) string {
	switch w {
	case time.Sunday:
		return "日曜日"
	case time.Monday:
		return "月曜日"
	case time.Tuesday:
		return "火曜日"
	case time.Wednesday:
		return "水曜日"
	case time.Thursday:
		return "木曜日"
	case time.Friday:
		return "金曜日"
	case time.Saturday:
		return "土曜日"
	case ifc.NoWeekday:
		return "不明な曜日"
	default:
		panic("hollo-international-fixed-calendar: unknown weekday in weekdayString")
	}
}
