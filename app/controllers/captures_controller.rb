class CapturesController < ApplicationController
  def new

  end

  def execute
    driver = Selenium::WebDriver.for :chrome
    driver.get("https://sugureware.com/page-8/")
    get_screenshot(driver)
  end


###以下、メソッド###

  def get_screenshot(driver)

		# 表示領域の大きさ
		innerH = driver.execute_script("return document.compatMode == 'BackCompat' ? document.body.clientHeight : document.documentElement.clientHeight").to_i
		innerW = driver.execute_script("return document.compatMode == 'BackCompat' ? document.body.clientWidth : document.documentElement.clientWidth").to_i
		
		# コンテンツ全体の長さ
		scrollH = driver.execute_script("return document.documentElement.scrollHeight").to_i
		scrollW = driver.execute_script("return document.documentElement.scrollWidth").to_i

		# 表示領域の大きさがコンテンツ全体の長さより大きい場合
		if innerH > scrollH then
			innerH = scrollH
		end
		if innerW > scrollW then
			innerW = scrollW
		end
		
		# ImageMagick を使う
		image = Magick::Image.new(scrollW,scrollH){self.background_color = "red"}
		
		x = 0
		
		while x < scrollW 
			if x + innerW > scrollW then
				x = scrollW - innerW
			end

			y = 0
      vertical_scroll_count = 0   # 縦方向にスクロールした回数を数える

      while y < scrollH 
				if y + innerH > scrollH then
					y = scrollH - innerH
        end
        
        vertical_scroll_count += 1
        if vertical_scroll_count > 1
          driver.execute_script("return document.getElementsByTagName('header')[0].style.visibility='hidden'")
          sleep 1
        end
				
				# スクロール位置を移動
				driver.execute_script("window.scrollTo(" + x.to_s + "," + y.to_s + ")")
				
				# PNG 形式でスクリーンショットを取得する
				binary = driver.screenshot_as(:png)
				
				# RMagick 形式にする
				oneImage = Magick::Image.from_blob(binary).first
				
				# 画像を結合
				image.composite!(oneImage, x, y, Magick::OverCompositeOp)
				
				y += innerH
			end
			
			x += innerW
		end
    
    # ファイルに書き込む
		image.write('screenshot.png')
	end
	
end
