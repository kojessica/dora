Parse.Cloud.afterSave("Post", function(request) {
  var query = new Parse.Query("Groups");
  query.get(request.object.get("groupId"), {
    success: function(group) {
        group.increment("totalPosts");
        group.set("secondPost", group.get("firstPost"));
        group.set("firstPost", request.object.get("text"));
        group.save();
		Parse.Push.send({
		channels: [ group.get("name") ],
		data: {
		 text: request.object.get("text")
		}
		}, { success: function() { 
			console.log("Pushed successfully!");
		// success!
		}, error: function(err) { 
		console.log(err);
		}
		});

    },
    error: function(error) {
      console.error("Got an error " + error.code + " : " + error.message);
    }
  });

});
