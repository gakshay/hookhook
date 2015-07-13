class MessagesController < ApplicationController
  before_filter :authenticate_user!

  def create
    @conversation = Conversation.find(params[:conversation_id])
    @message = @conversation.messages.build(message_params)
    @message.user_id = current_user.id
    @message.save!
    PrivatePub.publish_to "/chatroom_#{@conversation.recipient_id}", :conversation_id => @conversation.id
    @path = conversation_path(@conversation)
  end

  private

  def message_params
    params.require(:message).permit(:body)
  end
end
