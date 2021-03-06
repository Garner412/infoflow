# comment/new

# get - question/:id/comments/new
# post
# answer/:id/comments/new

get '/questions/:id/comments/new' do
  @question = Question.find(params[:id])
  erb :'/comments/new'
end

post '/questions/:id/comments' do
  @question = Question.find(params[:id])
  comment = Comment.create(text: params[:comment_text], user_id: logged_in_user.id,  commentable_id: params[:id], commentable_type: 'Question')
  if request.xhr?
    erb :"/comments/_question_comment", layout: false, locals: {question: @question, qcomment: comment}
  else
    redirect "/questions/#{params[:id]}"
  end
end

post '/answers/:id/comments/new' do
  @answer = Answer.find(params[:id])
  comment = Comment.create(text: params[:comment_text], user_id: @answer.user_id, commentable_id: params[:id], commentable_type: "Answer")
  if request.xhr?
    erb :'/comments/_answer_comment', layout: false, locals: {answer: @answer, acomment: comment }
  else
    redirect "/questions/#{@answer.question_id}"
  end
end

post "/comments/:id/vote" do
  if logged_in?
    vote = Vote.create(voteable_id: params[:id], voteable_type: "Comment")
  end
  comment = vote.voteable_type.classify.constantize.find(vote.voteable_id)
  @question = comment.commentable_type.classify.constantize.find(comment.commentable_id)
  if request.xhr?
    comment.votes.count.to_s
  else
    redirect "/questions/#{@question.id}"
  end
end
