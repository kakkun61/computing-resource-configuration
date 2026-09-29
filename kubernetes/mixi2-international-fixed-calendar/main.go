package main

import (
	"context"
	"crypto/tls"
	"fmt"
	"log"
	"os"
	"time"

	ifc "github.com/kakkun61/go-international-fixed-calendar"
	"github.com/mixigroup/mixi2-application-sdk-go/auth"
	application_apiv1 "github.com/mixigroup/mixi2-application-sdk-go/gen/go/social/mixi/application/service/application_api/v1"
	"google.golang.org/grpc"
	"google.golang.org/grpc/credentials"
)

const (
	API_ADDRESS = "application-api.mixi.social"
)

func main() {
	clientId := os.Getenv("CLIENT_ID")
	if clientId == "" {
		log.Fatal("CLIENT_ID is not set")
	}

	clientSecret := os.Getenv("CLIENT_SECRET")
	if clientSecret == "" {
		log.Fatal("CLIENT_SECRET is not set")
	}

	authenticator, err := auth.NewAuthenticator(clientId, clientSecret, "https://application-auth.mixi.social/oauth2/token")
	if err != nil {
		log.Fatal(err)
	}

	// gRPC リクエスト用のコンテキストを取得
	ctx, err := authenticator.AuthorizedContext(context.Background())
	if err != nil {
		log.Fatal(err)
	}

	// Create gRPC connection for API
	conn, err := grpc.NewClient(
		API_ADDRESS,
		grpc.WithTransportCredentials(credentials.NewTLS(&tls.Config{})),
	)
	if err != nil {
		log.Fatalf("failed to connect to api: %v", err)
	}
	defer conn.Close()

	client := application_apiv1.NewApplicationServiceClient(conn)

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

	// ctx を使って gRPC リクエストを送信
	resp, err := client.CreatePost(ctx, &application_apiv1.CreatePostRequest{
		Text: message,
	})
	if err != nil {
		log.Fatalf("failed to create post: %v", err)
	}

	log.Printf("Post created successfully: %s", resp.String())
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
		panic("mixi2-international-fixed-calendar: unknown weekday in weekdayString")
	}
}
