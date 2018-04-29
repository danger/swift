// This file simply declares the AutoEquatable protocol,
// which tells Sourcery to generate equatable extensions.

import Danger

public protocol AutoEquatable {}

extension Git: AutoEquatable {}
extension GitCommit: AutoEquatable {}
extension GitCommitAuthor: AutoEquatable {}

extension GitHubUser: AutoEquatable {}
extension GitHubMilestone: AutoEquatable {}
extension GitHub: AutoEquatable {}
extension GitHubPR: AutoEquatable {}
extension GitHubTeam: AutoEquatable {}
extension GitHubRequestedReviewers: AutoEquatable {}
extension GitHubMergeRef: AutoEquatable {}
extension GitHubRepo: AutoEquatable {}
extension GitHubReview: AutoEquatable {}
extension GitHubCommit: AutoEquatable {}
extension GitHubIssue: AutoEquatable {}
extension GitHubIssueLabel: AutoEquatable {}

extension BitBucketServerUser: AutoEquatable {}
extension BitBucketServerActivity: AutoEquatable {}
extension BitBucketServerPR: AutoEquatable {}
extension BitBucketServerRepo: AutoEquatable {}
extension BitBucketServerProject: AutoEquatable {}
extension BitBucketServerComment: AutoEquatable {}
extension BitBucketServerMergeRef: AutoEquatable {}
extension BitBucketServerMetadata: AutoEquatable {}
extension BitBucketServer: AutoEquatable {}
extension BitBucketServerCommit: AutoEquatable {}
extension BitBucketServerCommit.BitBucketServerCommitParent: AutoEquatable {}
extension BitBucketServerPR.BitBucketServerAuthor: AutoEquatable {}
extension BitBucketServerComment.BitBucketServerCommentInner: AutoEquatable {}
extension BitBucketServerComment.BitBucketServerCommentInner.BitBucketServerCommentInnerProperties: AutoEquatable {}
extension BitBucketServerComment.BitBucketServerCommentInner.BitBucketServerCommentTask: AutoEquatable {}
