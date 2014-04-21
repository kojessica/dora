Parse.Cloud.afterSave("Post", function(request) {
  var query = new Parse.Query("Groups");
  query.get(request.object.get("groupId"), {
    success: function(group) {
        group.increment("totalPosts");
        group.set("secondPost", group.get("firstPost"));
        group.set("firstPost", request.object.get("text"));
        group.save();
    },
    error: function(error) {
      console.error("Got an error " + error.code + " : " + error.message);
    }
  });
});
