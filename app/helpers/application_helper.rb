module ApplicationHelper
  # TODO: refactor code
  # ページごとの完全なタイトルを返します。
  def full_title(page_title = '')
    base_title = "Checkparam"
    if page_title.empty?
      base_title
    else
      page_title + " | " + base_title
    end
  end
end