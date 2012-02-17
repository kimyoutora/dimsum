$(document).live( 'pageinit', function(event){
  $(".list.row").bind('swipeleft', function(event) {
    // delete it
    deleteList($(event.target));
  }).bind('swiperight', function(event) {
    // mark it as done
    $(event.target).addClass("completed");
  });
  $(document).bind('scrollstop', function(event) {
    if($(this).scrollTop() == 0) {
      showNewTaskForm();
    } else {
      hideNewTaskForm();
    }
  });

  $("form").submit(function(event) {
    $.ajax({
      url: '/lists.json',
      type: 'POST',
      data: $(this).serialize(),
      success: function(resp) {
        window.location = window.location;
      }
    });
    return false;
  });

  var showNewTaskForm = function() {
    $("#new-task-form").show();
  };

  var hideNewTaskForm = function() {
    $("#new-task-form").hide();
  };

  var deleteList = function(dom) {
    var id = dom.attr("data-list-id");
    $.ajax({
      url: "/lists/"+id+".json",
      type: 'DELETE',
      success: function(resp) {
        dom.hide();
      }
    });
  };
});

