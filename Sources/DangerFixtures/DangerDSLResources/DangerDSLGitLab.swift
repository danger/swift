public let DSLGitLabJSON = """
{
  "danger": {
    "git": {
      "modified_files": [
        "static/source/swift/guides/getting_started.html.slim"
      ],
      "created_files": [],
      "deleted_files": [],
      "commits": [
        {
          "sha": "621bc3348549e51c5bd6ea9f094913e9e4667c7b",
          "author": {
            "name": "Franco Meloni",
            "email": "franco.meloni91@gmail.com",
            "date": "2019-04-10T21:56:43.000Z"
          },
          "committer": {
            "name": "Franco Meloni",
            "email": "franco.meloni91@gmail.com",
            "date": "2019-04-10T21:56:43.000Z"
          },
          "message": "Update getting_started.html.slim",
          "parents": [],
          "url": "https://gitlab.com/danger-systems/danger.systems/commit/621bc3348549e51c5bd6ea9f094913e9e4667c7b",
          "tree": null
        }
      ]
    },
    "gitlab": {
      "metadata": {
        "pullRequestID": "182",
        "repoSlug": "danger-systems/danger.systems"
      },
      "mr": {
        "id": 27469633,
        "iid": 182,
        "project_id": 1620437,
        "title": "Update getting_started.html.slim",
        "description": "Updating it to avoid problems like https://github.com/danger/swift/issues/221",
        "state": "merged",
        "created_at": "2019-04-10T21:57:45.346Z",
        "updated_at": "2019-04-11T00:37:22.460Z",
        "merged_by": {
          "id": 377669,
          "name": "Orta",
          "username": "orta",
          "state": "active",
          "avatar_url": "https://secure.gravatar.com/avatar/f116cb3be23153ec08b94e8bd4dbcfeb?s=80&d=identicon",
          "web_url": "https://gitlab.com/orta"
        },
        "merged_at": "2019-04-11T00:37:22.492Z",
        "closed_by": null,
        "closed_at": null,
        "target_branch": "master",
        "source_branch": "patch-2",
        "user_notes_count": 0,
        "upvotes": 0,
        "downvotes": 0,
        "assignee": {
          "id": 377669,
          "name": "Orta",
          "username": "orta",
          "state": "active",
          "avatar_url": "https://secure.gravatar.com/avatar/f116cb3be23153ec08b94e8bd4dbcfeb?s=80&d=identicon",
          "web_url": "https://gitlab.com/orta"
        },
        "author": {
          "id": 3331525,
          "name": "Franco Meloni",
          "username": "f-meloni",
          "state": "active",
          "avatar_url": "https://secure.gravatar.com/avatar/3d90e967de2beab6d44cfadbb4976b87?s=80&d=identicon",
          "web_url": "https://gitlab.com/f-meloni"
        },
        "assignees": [
          {
            "id": 377669,
            "name": "Orta",
            "username": "orta",
            "state": "active",
            "avatar_url": "https://secure.gravatar.com/avatar/f116cb3be23153ec08b94e8bd4dbcfeb?s=80&d=identicon",
            "web_url": "https://gitlab.com/orta"
          }
        ],
        "reviewers": [
          {
            "id": 377669,
            "name": "Orta",
            "username": "orta",
            "state": "active",
            "avatar_url": "https://secure.gravatar.com/avatar/f116cb3be23153ec08b94e8bd4dbcfeb?s=80&d=identicon",
            "web_url": "https://gitlab.com/orta"
          }
        ],
        "source_project_id": 10132593,
        "target_project_id": 1620437,
        "labels": [],
        "work_in_progress": false,
        "milestone": {
          "id": 1,
          "iid": 2,
          "project_id": 1000,
          "title": "Test Milestone",
          "description": "Test Description",
          "state": "closed",
          "start_date": "2019-04-10",
          "created_at": "2019-04-10T21:57:45.346Z",
          "updated_at": "2019-04-10T21:57:45.346Z",
          "due_date": "2019-06-10",
          "web_url": "https://gitlab.com/milestone"
        },
        "merge_when_pipeline_succeeds": false,
        "merge_status": "can_be_merged",
        "sha": "621bc3348549e51c5bd6ea9f094913e9e4667c7b",
        "merge_commit_sha": "377a24fb7a0f30364f089f7bca67752a8b61f477",
        "discussion_locked": null,
        "should_remove_source_branch": null,
        "force_remove_source_branch": true,
        "allow_collaboration": false,
        "allow_maintainer_to_push": false,
        "reference": "!182",
        "web_url": "https://gitlab.com/danger-systems/danger.systems/merge_requests/182",
        "time_stats": {
          "time_estimate": 12600,
          "total_time_spent": 12600,
          "human_time_estimate": "3h 30m",
          "human_total_time_spent": "3h 30m",
        },
        "squash": false,
        "subscribed": false,
        "changes_count": "1",
        "latest_build_started_at": "2019-04-11T00:20:22.492Z",
        "latest_build_finished_at": "2019-04-11T00:33:22.492Z",
        "first_deployed_to_production_at": "2019-04-11T00:30:22.492Z",
        "pipeline": {
          "id": 50,
          "sha": "621bc3348549e51c5bd6ea9f094913e9e4667c7b",
          "ref": "ef28580bb2a00d985bffe4a4ce3fe09fdb12283f",
          "status": "success",
          "web_url": "https://gitlab.com/danger-systems/danger.systems/pipeline/621bc3348549e51c5bd6ea9f094913e9e4667c7b"
        },
        "head_pipeline": null,
        "diff_refs": {
          "base_sha": "ef28580bb2a00d985bffe4a4ce3fe09fdb12283f",
          "head_sha": "621bc3348549e51c5bd6ea9f094913e9e4667c7b",
          "start_sha": "ef28580bb2a00d985bffe4a4ce3fe09fdb12283f"
        },
        "merge_error": null,
        "user": {
          "can_merge": false
        },
        "approvals_before_merge": 1
      },
      "commits": [
        {
          "id": "621bc3348549e51c5bd6ea9f094913e9e4667c7b",
          "short_id": "621bc334",
          "created_at": "2019-04-10T21:56:43.000Z",
          "parent_ids": [],
          "title": "Update getting_started.html.slim",
          "message": "Update getting_started.html.slim",
          "author_name": "Franco Meloni",
          "author_email": "franco.meloni91@gmail.com",
          "authored_date": "2019-04-10T21:56:43.000Z",
          "committer_name": "Franco Meloni",
          "committer_email": "franco.meloni91@gmail.com",
          "committed_date": "2019-04-10T21:56:43.000Z"
        }
      ]
    },
    "settings": {
      "github": {
        "accessToken": "NO_T...",
        "additionalHeaders": {}
      },
      "cliArgs": {}
    }
  }
}
"""
