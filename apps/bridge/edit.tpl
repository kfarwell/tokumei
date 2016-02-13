<div id="reply-form">
  <form action="" method="POST">
   <div class="input-field">
     <textarea name="comment" id="comment%($postnum%)" class="materialize-textarea validate" required="" length="140" maxlength="140"></textarea>
     <label for="comment%($postnum%)">Message</label>
   </div>

   <input type="hidden" name="parent" value="%($postnum%)">

   <button type="submit" class="btn-large waves-effect waves-light pink">Reply<i class="mdi mdi-send right"></i></button>
  </form>
</div>
<div id="reply-form-disabled">No replies yet!</div>
