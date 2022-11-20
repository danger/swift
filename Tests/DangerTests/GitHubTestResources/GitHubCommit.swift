public let GitHubCommitWithEmptyAuthorJSON = """
{
	"sha": "cad494648f773cd4fad5a9ea948c1bfabf36032a",
	"node_id": "MDY6Q29tbWl0MTAxMzM5MjEyOmNhZDQ5NDY0OGY3NzNjZDRmYWQ1YTllYTk0OGMxYmZhYmYzNjAzMmE=",
	"commit": {
	  "author": {
	    "name": "Franco Meloni",
	    "email": "franco.meloni91@gmail.com",
	    "date": "2019-04-20T17:46:50Z"
	  },
	  "committer": {
	    "name": "Franco Meloni",
	    "email": "franco.meloni91@gmail.com",
	    "date": "2019-04-20T17:46:50Z"
	  },
	  "message": "Re use the same executor on the runner",
	  "tree": {
	    "sha": "96b7fdf0ab04926cc9eee844a15d66e097922777",
	    "url": "https://api.github.com/repos/danger/swift/git/trees/96b7fdf0ab04926cc9eee844a15d66e097922777"
	  },
	  "url": "https://api.github.com/repos/danger/swift/git/commits/cad494648f773cd4fad5a9ea948c1bfabf36032a",
	  "comment_count": 0,
	  "verification": {
	    "verified": false,
	    "reason": "unknown_signature_type",
	    "signature": null,
	    "payload": null
	  }
	},
	"url": "https://api.github.com/repos/danger/swift/commits/cad494648f773cd4fad5a9ea948c1bfabf36032a",
	"html_url": "https://github.com/danger/swift/commit/cad494648f773cd4fad5a9ea948c1bfabf36032a",
	"comments_url": "https://api.github.com/repos/danger/swift/commits/cad494648f773cd4fad5a9ea948c1bfabf36032a/comments",
	"author": {},
	"committer": {
	  "login": "f-meloni",
	  "id": 17830956,
	  "node_id": "MDQ6VXNlcjE3ODMwOTU2",
	  "avatar_url": "https://avatars1.githubusercontent.com/u/17830956?v=4",
	  "gravatar_id": "",
	  "url": "https://api.github.com/users/f-meloni",
	  "html_url": "https://github.com/f-meloni",
	  "followers_url": "https://api.github.com/users/f-meloni/followers",
	  "following_url": "https://api.github.com/users/f-meloni/following{/other_user}",
	  "gists_url": "https://api.github.com/users/f-meloni/gists{/gist_id}",
	  "starred_url": "https://api.github.com/users/f-meloni/starred{/owner}{/repo}",
	  "subscriptions_url": "https://api.github.com/users/f-meloni/subscriptions",
	  "organizations_url": "https://api.github.com/users/f-meloni/orgs",
	  "repos_url": "https://api.github.com/users/f-meloni/repos",
	  "events_url": "https://api.github.com/users/f-meloni/events{/privacy}",
	  "received_events_url": "https://api.github.com/users/f-meloni/received_events",
	  "type": "User",
	  "site_admin": false
	},
	"parents": [
	]
}
"""

public let GitHubCommitVerifiedJSON = """
{
    "sha": "cad494648f773cd4fad5a9ea948c1bfabf36032a",
    "node_id": "MDY6Q29tbWl0MTAxMzM5MjEyOmNhZDQ5NDY0OGY3NzNjZDRmYWQ1YTllYTk0OGMxYmZhYmYzNjAzMmE=",
    "commit": {
      "author": {
        "name": "Franco Meloni",
        "email": "franco.meloni91@gmail.com",
        "date": "2019-04-20T17:46:50Z"
      },
      "committer": {
        "name": "Franco Meloni",
        "email": "franco.meloni91@gmail.com",
        "date": "2019-04-20T17:46:50Z"
      },
      "message": "Re use the same executor on the runner",
      "tree": {
        "sha": "96b7fdf0ab04926cc9eee844a15d66e097922777",
        "url": "https://api.github.com/repos/danger/swift/git/trees/96b7fdf0ab04926cc9eee844a15d66e097922777"
      },
      "url": "https://api.github.com/repos/danger/swift/git/commits/cad494648f773cd4fad5a9ea948c1bfabf36032a",
      "comment_count": 0,
      "verification": {
        "verified": true,
        "reason": "valid",
        "signature": "Test Signature",
        "payload": "Test Payload"
      }
    },
    "url": "https://api.github.com/repos/danger/swift/commits/cad494648f773cd4fad5a9ea948c1bfabf36032a",
    "html_url": "https://github.com/danger/swift/commit/cad494648f773cd4fad5a9ea948c1bfabf36032a",
    "comments_url": "https://api.github.com/repos/danger/swift/commits/cad494648f773cd4fad5a9ea948c1bfabf36032a/comments",
    "author": {},
    "committer": {
      "login": "f-meloni",
      "id": 17830956,
      "node_id": "MDQ6VXNlcjE3ODMwOTU2",
      "avatar_url": "https://avatars1.githubusercontent.com/u/17830956?v=4",
      "gravatar_id": "",
      "url": "https://api.github.com/users/f-meloni",
      "html_url": "https://github.com/f-meloni",
      "followers_url": "https://api.github.com/users/f-meloni/followers",
      "following_url": "https://api.github.com/users/f-meloni/following{/other_user}",
      "gists_url": "https://api.github.com/users/f-meloni/gists{/gist_id}",
      "starred_url": "https://api.github.com/users/f-meloni/starred{/owner}{/repo}",
      "subscriptions_url": "https://api.github.com/users/f-meloni/subscriptions",
      "organizations_url": "https://api.github.com/users/f-meloni/orgs",
      "repos_url": "https://api.github.com/users/f-meloni/repos",
      "events_url": "https://api.github.com/users/f-meloni/events{/privacy}",
      "received_events_url": "https://api.github.com/users/f-meloni/received_events",
      "type": "User",
      "site_admin": false
    },
    "parents": [
    ]
}
"""
