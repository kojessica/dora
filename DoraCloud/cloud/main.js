Parse.Cloud.beforeSave("Post", function(request) {
  var query = new Parse.Query("Groups");
  query.get(request.object.get("groupId"), {
    success: function(group) {
    	if(!request.object.existed()) {
 	        group.increment("totalPosts");
	        group.set("secondPost", group.get("firstPost"));
	        group.set("firstPost", request.object.get("text"));
	    	group.save();
    	}
    	Parse.Push.send({
		channels: [ group.get("name") ],
		data: {
		 objectId: request.object.id,
		 groupId: request.object.get("groupId"),
		 userId: request.object.get("userId"),
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
