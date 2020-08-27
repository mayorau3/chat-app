class MessagesController < ApplicationController
  def index
    @message = Message.new
    @room = Room.find(params[:room_id])
    @messages = @room.messages.includes(:user)
  end

  def create
    @room = Room.find(params[:room_id])
    @message = @room.messages.new(message_params)
    if @message.save  # @roomに投稿された全てのmessagesを保存
      redirect_to room_messages_path(@room)
    else
      @messages = @room.messages.includes(:user)
      # renderでindex.html.erbを参照するが、indexアクションは経由しないため、@messagesにルーム内のメッセージを代入しておく
      render :index
    end
  end

  private

  def message_params
    params.require(:message).permit(:content, :image).merge(user_id: current_user.id)

  end
end