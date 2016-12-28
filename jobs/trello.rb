require 'trello'

include Trello

Trello.configure do |config|
  config.developer_public_key = '7906a3a8f4b6f195c9cb1943d1e25b14'
  config.member_token = '224a51f3dbea2be903252bf6e5f00970cf52d90d91a479e3c437cfa878d2a96f'
end

boards = {
  "my-trello-board" => "UEmGMI14",
}

class MyTrello
  def initialize(widget_id, board_id)
    @widget_id = widget_id
    @board_id = board_id
  end

  def widget_id()
    @widget_id
  end

  def board_id()
    @board_id
  end

  def status_list()
    status = Array.new
    Board.find(@board_id).lists.each do |list|
      status.push({label: list.name, value: list.cards.size})
    end
    status
  end
end

@MyTrello = []
boards.each do |widget_id, board_id|
  begin
    @MyTrello.push(MyTrello.new(widget_id, board_id))
  rescue Exception => e
    puts e.to_s
  end
end

SCHEDULER.every '5m', :first_in => 0 do |job|
  @MyTrello.each do |board|
    status = board.status_list()
    send_event(board.widget_id, { :items => status })
  end
end
