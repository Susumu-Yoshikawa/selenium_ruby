require 'selenium-webdriver'
require './selenium_const'


# ブラウザ起動
puts "ブラウザ起動"
driver = Selenium::WebDriver.for :chrome 

# ページ遷移
puts "ページ遷移"
driver.navigate.to URL1
sleep(SLEEP)

# ID,PASS入力
puts "ID,PASS入力"
element = driver.find_element(:id, 'user_login')
element.send_keys(LOGIN_ID)
element = driver.find_element(:id, 'user_password')
element.send_keys(PASSWORD)
driver.find_element(:class, 'uk-button').click
sleep(SLEEP)

# 稟議遷移
puts "稟議遷移"
driver.navigate.to URL2
sleep(SLEEP)

# 週報検索
puts "週報検索"
element = driver.find_element(:id, 'workflow_forms_participant_search_statuses_completed')
element.click
element = driver.find_element(:id, 'workflow_forms_participant_search_work_item_type_id')
select = Selenium::WebDriver::Support::Select.new(element)
select.select_by(:value, '1')    # valueの値で選択
element = driver.find_element(:class, 'uk-button-primary')
element.click
sleep(SLEEP)

# 対象稟議の一覧取得
puts "対象稟議の一覧取得(1)"
xpathTable = "/html[@class='uk-notouch']/body/div[@class='uk-block']/div[@class='uk-container uk-container-center']/div[@class='uk-overflow-container']/table[@class='uk-table uk-text-nowrap']/tbody/tr"
tableTextList = driver.find_elements(:xpath, xpathTable)
puts "検索結果：" + tableTextList.length.to_s + "件"

array = Array.new()

for i in 1..tableTextList.length do

  puts i.to_s + "件目"
  xpathLinkText = xpathTable + "[" + i.to_s + "]/td[1]/a"
  linkText = driver.find_element(:xpath, xpathLinkText)
  puts linkText.text
  #puts linkText.attribute("href")
  array.push(linkText.attribute("href"))

end

# ページング
xpathPaging = "/html[@class='uk-notouch']/body/div[@class='uk-block']/div[@class='uk-container uk-container-center']/div[@class='uk-align-right']/ul[@class='uk-pagination']/li[2]/a"
pagingText = driver.find_elements(:xpath, xpathPaging)

puts "2ページ目存在チェック：" + pagingText.length.to_s

if 0 < pagingText.length then

  pagingText[0].click

  puts "対象稟議の一覧取得(2)"
  xpathTable = "/html[@class='uk-notouch']/body/div[@class='uk-block']/div[@class='uk-container uk-container-center']/div[@class='uk-overflow-container']/table[@class='uk-table uk-text-nowrap']/tbody/tr"
  tableTextList = driver.find_elements(:xpath, xpathTable)
  puts "検索結果：" + tableTextList.length.to_s + "件"

#  array = Array.new()

  for i in 1..tableTextList.length do

    puts i.to_s + "件目"
    xpathLinkText = xpathTable + "[" + i.to_s + "]/td[1]/a"
    linkText = driver.find_element(:xpath, xpathLinkText)
    puts linkText.text
    #puts linkText.attribute("href")
    array.push(linkText.attribute("href"))

  end
end

puts array

#sleep(STOP)

# ブラウザ終了
driver.quit
