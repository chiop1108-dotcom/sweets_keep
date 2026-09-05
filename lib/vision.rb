# 写真を「暗号のような特別な文字」に変える
require "base64"
# データをロボットが読みやすい形にきれいに並べる
require "json"
# インターネットを通してデータを遠くのロボットに届ける
require "net/https"

# 「Vision（ビジョン）」という部屋を作って、「写真のデータをもらってくるお仕事（get_image_data）」を始めます！ と宣言
module Vision
  class << self
    # image_attachment（画像ファイル）を渡されると、このお仕事が動き出す
    def get_image_data(image_attachment)
      # 「もし写真が添付されていなかったら、何もせずにからっぽ（[]）で返るよ！」 という確認
      return [] unless image_attachment.attached?

      api_url = "https://vision.googleapis.com/v1/images:annotate?key=#{ENV['GOOGLE_API_KEY']}"

      # Rails 8: Active Storage の download メソッドを使用
      # 写真を「文字の暗号」に変える
      base64_image = Base64.strict_encode64(image_attachment.download)

      # データを「ロボットが理解できる形」に変える
      params = {
        requests: [{
          image: {
            content: base64_image
          },
          features: [
            {
              type: "LABEL_DETECTION"
            }
          ] # ,
          # # タグを日本語にする
          # imageContext: {
          #   languageHints: ["ja"] # 日本語を優先して返すように指定
          # }
        }]
      }.to_json

      # インターネットを通して、ロボットにデータを届ける
      uri = URI.parse(api_url)
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      request = Net::HTTP::Post.new(uri.request_uri)
      request["Content-Type"] = "application/json"
      response = https.request(request, params)
      # 返ってきたデータを「人間が理解できる形」に変える
      response_body = JSON.parse(response.body)

      # もしロボットが「エラーが起きたよ！」と教えてくれたら、エラーメッセージをログに書き込んで、エラーを投げる
      if (error = response_body.dig("responses", 0, "error")).present?
        Rails.logger.error("Vision API Error: #{error['message']}")
        raise error["message"]
      else
        # タグを日本語化できるように調整のため、コメントアウトにする
        # response_body.dig("responses", 0, "labelAnnotations")&.pluck("description")&.take(3) || []

        # 1. Vision APIから英語タグの配列を取得（例: ["Cake", "Dish", "Sweetness"]）
        english_tags = response_body.dig("responses", 0, "labelAnnotations")&.pluck("description")&.take(3) || []
        
        # 2. 英語タグが存在すれば、翻訳メソッドを呼び出して日本語に変換して返す
        translate_to_japanese(english_tags)
      end
    end

    # タグを日本語化するために追記
    
    private

    # 【新規追加】英語配列を受け取って日本語配列に変換するメソッド
    def translate_to_japanese(words)
      return [] if words.empty?

      # Google Cloud Translation API (v2) のエンドポイント URL
      translate_api_url = "https://translation.googleapis.com/language/translate/v2?key=#{ENV['GOOGLE_API_KEY']}"

      # APIに渡すパラメータの設定（target: 'ja' で日本語を指定）
      params = {
        q: words,       # 翻訳したい文字列の配列
        target: "ja",   # 翻訳後の言語（日本語）
        format: "text"  # フォーマット指定
      }.to_json

      uri = URI.parse(translate_api_url)
      https = Net::HTTP.new(uri.host, uri.port)
      https.use_ssl = true
      request = Net::HTTP::Post.new(uri.request_uri)
      request["Content-Type"] = "application/json"
      
      response = https.request(request, params)
      response_body = JSON.parse(response.body)

      if (error = response_body["error"]).present?
        Rails.logger.error("Translation API Error: #{error['message']}")
        # 翻訳に失敗した場合は、フォールバックとして元の英語タグを返す
        words
      else
        # 翻訳されたテキストだけを抜き出して配列で返す（例: ["ケーキ", "料理", "甘さ"]）
        translations = response_body.dig("data", "translations") || []
        translations.map { |t| t["translatedText"] }
      end
    end

  end
end