// Generated using Sourcery 0.11.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT

import Danger

// swiftlint:disable file_length
fileprivate func compareOptionals<T>(lhs: T?, rhs: T?, compare: (_ lhs: T, _ rhs: T) -> Bool) -> Bool {
    switch (lhs, rhs) {
    case let (lValue?, rValue?):
        return compare(lValue, rValue)
    case (nil, nil):
        return true
    default:
        return false
    }
}

fileprivate func compareArrays<T>(lhs: [T], rhs: [T], compare: (_ lhs: T, _ rhs: T) -> Bool) -> Bool {
    guard lhs.count == rhs.count else { return false }
    for (idx, lhsItem) in lhs.enumerated() {
        guard compare(lhsItem, rhs[idx]) else { return false }
    }

    return true
}


// MARK: - AutoEquatable for classes, protocols, structs
// MARK: - BitBucketServer AutoEquatable
extension BitBucketServer: Equatable {}
public func == (lhs: BitBucketServer, rhs: BitBucketServer) -> Bool {
    guard lhs.metadata == rhs.metadata else { return false }
    guard lhs.pullRequest == rhs.pullRequest else { return false }
    guard lhs.commits == rhs.commits else { return false }
    guard lhs.comments == rhs.comments else { return false }
    guard lhs.activities == rhs.activities else { return false }
    return true
}
// MARK: - BitBucketServerActivity AutoEquatable
extension BitBucketServerActivity: Equatable {}
public func == (lhs: BitBucketServerActivity, rhs: BitBucketServerActivity) -> Bool {
    guard lhs.id == rhs.id else { return false }
    guard lhs.createdDate == rhs.createdDate else { return false }
    guard lhs.user == rhs.user else { return false }
    guard lhs.action == rhs.action else { return false }
    guard compareOptionals(lhs: lhs.commentAction, rhs: rhs.commentAction, compare: ==) else { return false }
    return true
}
// MARK: - BitBucketServerComment AutoEquatable
extension BitBucketServerComment: Equatable {}
public func == (lhs: BitBucketServerComment, rhs: BitBucketServerComment) -> Bool {
    guard lhs.id == rhs.id else { return false }
    guard lhs.createdDate == rhs.createdDate else { return false }
    guard lhs.user == rhs.user else { return false }
    guard lhs.action == rhs.action else { return false }
    guard compareOptionals(lhs: lhs.fromHash, rhs: rhs.fromHash, compare: ==) else { return false }
    guard compareOptionals(lhs: lhs.previousFromHash, rhs: rhs.previousFromHash, compare: ==) else { return false }
    guard compareOptionals(lhs: lhs.toHash, rhs: rhs.toHash, compare: ==) else { return false }
    guard compareOptionals(lhs: lhs.previousToHash, rhs: rhs.previousToHash, compare: ==) else { return false }
    guard compareOptionals(lhs: lhs.commentAction, rhs: rhs.commentAction, compare: ==) else { return false }
    guard compareOptionals(lhs: lhs.comment, rhs: rhs.comment, compare: ==) else { return false }
    return true
}
// MARK: - BitBucketServerComment.BitBucketServerCommentInner AutoEquatable
extension BitBucketServerComment.BitBucketServerCommentInner: Equatable {}
public func == (lhs: BitBucketServerComment.BitBucketServerCommentInner, rhs: BitBucketServerComment.BitBucketServerCommentInner) -> Bool {
    guard lhs.id == rhs.id else { return false }
    guard lhs.version == rhs.version else { return false }
    guard lhs.text == rhs.text else { return false }
    guard lhs.author == rhs.author else { return false }
    guard lhs.createdAt == rhs.createdAt else { return false }
    guard lhs.updatedAt == rhs.updatedAt else { return false }
    guard lhs.comments == rhs.comments else { return false }
    guard lhs.properties == rhs.properties else { return false }
    guard lhs.tasks == rhs.tasks else { return false }
    return true
}
// MARK: - BitBucketServerComment.BitBucketServerCommentInner.BitBucketServerCommentInnerProperties AutoEquatable
extension BitBucketServerComment.BitBucketServerCommentInner.BitBucketServerCommentInnerProperties: Equatable {}
public func == (lhs: BitBucketServerComment.BitBucketServerCommentInner.BitBucketServerCommentInnerProperties, rhs: BitBucketServerComment.BitBucketServerCommentInner.BitBucketServerCommentInnerProperties) -> Bool {
    guard lhs.repositoryId == rhs.repositoryId else { return false }
    guard compareOptionals(lhs: lhs.issues, rhs: rhs.issues, compare: ==) else { return false }
    return true
}
// MARK: - BitBucketServerComment.BitBucketServerCommentInner.BitBucketServerCommentTask AutoEquatable
extension BitBucketServerComment.BitBucketServerCommentInner.BitBucketServerCommentTask: Equatable {}
public func == (lhs: BitBucketServerComment.BitBucketServerCommentInner.BitBucketServerCommentTask, rhs: BitBucketServerComment.BitBucketServerCommentInner.BitBucketServerCommentTask) -> Bool {
    guard lhs.id == rhs.id else { return false }
    guard lhs.createdDate == rhs.createdDate else { return false }
    guard lhs.text == rhs.text else { return false }
    guard lhs.state == rhs.state else { return false }
    guard lhs.author == rhs.author else { return false }
    return true
}
// MARK: - BitBucketServerCommit AutoEquatable
extension BitBucketServerCommit: Equatable {}
public func == (lhs: BitBucketServerCommit, rhs: BitBucketServerCommit) -> Bool {
    guard lhs.id == rhs.id else { return false }
    guard lhs.displayId == rhs.displayId else { return false }
    guard lhs.author == rhs.author else { return false }
    guard lhs.authorTimestamp == rhs.authorTimestamp else { return false }
    guard lhs.committer == rhs.committer else { return false }
    guard lhs.committerTimestamp == rhs.committerTimestamp else { return false }
    guard lhs.message == rhs.message else { return false }
    guard lhs.parents == rhs.parents else { return false }
    return true
}
// MARK: - BitBucketServerCommit.BitBucketServerCommitParent AutoEquatable
extension BitBucketServerCommit.BitBucketServerCommitParent: Equatable {}
public func == (lhs: BitBucketServerCommit.BitBucketServerCommitParent, rhs: BitBucketServerCommit.BitBucketServerCommitParent) -> Bool {
    guard lhs.id == rhs.id else { return false }
    guard lhs.displayId == rhs.displayId else { return false }
    return true
}
// MARK: - BitBucketServerMergeRef AutoEquatable
extension BitBucketServerMergeRef: Equatable {}
public func == (lhs: BitBucketServerMergeRef, rhs: BitBucketServerMergeRef) -> Bool {
    guard lhs.id == rhs.id else { return false }
    guard lhs.displayId == rhs.displayId else { return false }
    guard lhs.latestCommit == rhs.latestCommit else { return false }
    guard lhs.repository == rhs.repository else { return false }
    return true
}
// MARK: - BitBucketServerMetadata AutoEquatable
extension BitBucketServerMetadata: Equatable {}
public func == (lhs: BitBucketServerMetadata, rhs: BitBucketServerMetadata) -> Bool {
    guard lhs.pullRequestID == rhs.pullRequestID else { return false }
    guard lhs.repoSlug == rhs.repoSlug else { return false }
    return true
}
// MARK: - BitBucketServerPR AutoEquatable
extension BitBucketServerPR: Equatable {}
public func == (lhs: BitBucketServerPR, rhs: BitBucketServerPR) -> Bool {
    guard lhs.id == rhs.id else { return false }
    guard lhs.version == rhs.version else { return false }
    guard lhs.title == rhs.title else { return false }
    guard lhs.description == rhs.description else { return false }
    guard lhs.state == rhs.state else { return false }
    guard lhs.open == rhs.open else { return false }
    guard lhs.closed == rhs.closed else { return false }
    guard lhs.createdAt == rhs.createdAt else { return false }
    guard compareOptionals(lhs: lhs.updatedAt, rhs: rhs.updatedAt, compare: ==) else { return false }
    guard lhs.fromRef == rhs.fromRef else { return false }
    guard lhs.toRef == rhs.toRef else { return false }
    guard lhs.isLocked == rhs.isLocked else { return false }
    guard lhs.author == rhs.author else { return false }
    guard lhs.reviewers == rhs.reviewers else { return false }
    guard lhs.participants == rhs.participants else { return false }
    return true
}
// MARK: - BitBucketServerPR.BitBucketServerAuthor AutoEquatable
extension BitBucketServerPR.BitBucketServerAuthor: Equatable {}
public func == (lhs: BitBucketServerPR.BitBucketServerAuthor, rhs: BitBucketServerPR.BitBucketServerAuthor) -> Bool {
    guard lhs.user == rhs.user else { return false }
    return true
}
// MARK: - BitBucketServerProject AutoEquatable
extension BitBucketServerProject: Equatable {}
public func == (lhs: BitBucketServerProject, rhs: BitBucketServerProject) -> Bool {
    guard lhs.id == rhs.id else { return false }
    guard lhs.key == rhs.key else { return false }
    guard lhs.name == rhs.name else { return false }
    guard lhs.isPublic == rhs.isPublic else { return false }
    guard lhs.type == rhs.type else { return false }
    return true
}
// MARK: - BitBucketServerRepo AutoEquatable
extension BitBucketServerRepo: Equatable {}
public func == (lhs: BitBucketServerRepo, rhs: BitBucketServerRepo) -> Bool {
    guard compareOptionals(lhs: lhs.name, rhs: rhs.name, compare: ==) else { return false }
    guard lhs.slug == rhs.slug else { return false }
    guard lhs.scmId == rhs.scmId else { return false }
    guard lhs.isPublic == rhs.isPublic else { return false }
    guard lhs.forkable == rhs.forkable else { return false }
    guard lhs.project == rhs.project else { return false }
    return true
}
// MARK: - BitBucketServerUser AutoEquatable
extension BitBucketServerUser: Equatable {}
public func == (lhs: BitBucketServerUser, rhs: BitBucketServerUser) -> Bool {
    guard lhs.id == rhs.id else { return false }
    guard lhs.name == rhs.name else { return false }
    guard lhs.displayName == rhs.displayName else { return false }
    guard lhs.emailAddress == rhs.emailAddress else { return false }
    guard lhs.active == rhs.active else { return false }
    guard lhs.slug == rhs.slug else { return false }
    guard lhs.type == rhs.type else { return false }
    return true
}
// MARK: - Git AutoEquatable
extension Git: Equatable {}
public func == (lhs: Git, rhs: Git) -> Bool {
    guard lhs.modifiedFiles == rhs.modifiedFiles else { return false }
    guard lhs.createdFiles == rhs.createdFiles else { return false }
    guard lhs.deletedFiles == rhs.deletedFiles else { return false }
    return true
}
// MARK: - GitCommit AutoEquatable
extension GitCommit: Equatable {}
public func == (lhs: GitCommit, rhs: GitCommit) -> Bool {
    guard compareOptionals(lhs: lhs.sha, rhs: rhs.sha, compare: ==) else { return false }
    guard lhs.author == rhs.author else { return false }
    guard lhs.committer == rhs.committer else { return false }
    guard lhs.message == rhs.message else { return false }
    guard compareOptionals(lhs: lhs.parents, rhs: rhs.parents, compare: ==) else { return false }
    guard lhs.url == rhs.url else { return false }
    return true
}
// MARK: - GitCommitAuthor AutoEquatable
extension GitCommitAuthor: Equatable {}
public func == (lhs: GitCommitAuthor, rhs: GitCommitAuthor) -> Bool {
    guard lhs.name == rhs.name else { return false }
    guard lhs.email == rhs.email else { return false }
    guard lhs.date == rhs.date else { return false }
    return true
}
// MARK: - GitHub AutoEquatable
extension GitHub: Equatable {}
public func == (lhs: GitHub, rhs: GitHub) -> Bool {
    guard lhs.issue == rhs.issue else { return false }
    guard lhs.pullRequest == rhs.pullRequest else { return false }
    guard lhs.commits == rhs.commits else { return false }
    guard lhs.reviews == rhs.reviews else { return false }
    guard lhs.requestedReviewers == rhs.requestedReviewers else { return false }
    return true
}
// MARK: - GitHubCommit AutoEquatable
extension GitHubCommit: Equatable {}
public func == (lhs: GitHubCommit, rhs: GitHubCommit) -> Bool {
    guard lhs.sha == rhs.sha else { return false }
    guard lhs.commit == rhs.commit else { return false }
    guard lhs.url == rhs.url else { return false }
    guard lhs.author == rhs.author else { return false }
    guard lhs.committer == rhs.committer else { return false }
    return true
}
// MARK: - GitHubIssue AutoEquatable
extension GitHubIssue: Equatable {}
public func == (lhs: GitHubIssue, rhs: GitHubIssue) -> Bool {
    guard lhs.id == rhs.id else { return false }
    guard lhs.number == rhs.number else { return false }
    guard lhs.title == rhs.title else { return false }
    guard lhs.user == rhs.user else { return false }
    guard lhs.state == rhs.state else { return false }
    guard lhs.isLocked == rhs.isLocked else { return false }
    guard lhs.body == rhs.body else { return false }
    guard lhs.commentCount == rhs.commentCount else { return false }
    guard compareOptionals(lhs: lhs.assignee, rhs: rhs.assignee, compare: ==) else { return false }
    guard lhs.assignees == rhs.assignees else { return false }
    guard compareOptionals(lhs: lhs.milestone, rhs: rhs.milestone, compare: ==) else { return false }
    guard lhs.createdAt == rhs.createdAt else { return false }
    guard lhs.updatedAt == rhs.updatedAt else { return false }
    guard compareOptionals(lhs: lhs.closedAt, rhs: rhs.closedAt, compare: ==) else { return false }
    guard lhs.labels == rhs.labels else { return false }
    return true
}
// MARK: - GitHubIssueLabel AutoEquatable
extension GitHubIssueLabel: Equatable {}
public func == (lhs: GitHubIssueLabel, rhs: GitHubIssueLabel) -> Bool {
    guard lhs.id == rhs.id else { return false }
    guard lhs.url == rhs.url else { return false }
    guard lhs.name == rhs.name else { return false }
    guard lhs.color == rhs.color else { return false }
    return true
}
// MARK: - GitHubMergeRef AutoEquatable
extension GitHubMergeRef: Equatable {}
public func == (lhs: GitHubMergeRef, rhs: GitHubMergeRef) -> Bool {
    guard lhs.label == rhs.label else { return false }
    guard lhs.ref == rhs.ref else { return false }
    guard lhs.sha == rhs.sha else { return false }
    guard lhs.user == rhs.user else { return false }
    guard lhs.repo == rhs.repo else { return false }
    return true
}
// MARK: - GitHubMilestone AutoEquatable
extension GitHubMilestone: Equatable {}
public func == (lhs: GitHubMilestone, rhs: GitHubMilestone) -> Bool {
    guard lhs.id == rhs.id else { return false }
    guard lhs.number == rhs.number else { return false }
    guard lhs.state == rhs.state else { return false }
    guard lhs.title == rhs.title else { return false }
    guard lhs.description == rhs.description else { return false }
    guard lhs.creator == rhs.creator else { return false }
    guard lhs.openIssues == rhs.openIssues else { return false }
    guard lhs.closedIssues == rhs.closedIssues else { return false }
    guard lhs.createdAt == rhs.createdAt else { return false }
    guard lhs.updatedAt == rhs.updatedAt else { return false }
    guard compareOptionals(lhs: lhs.closedAt, rhs: rhs.closedAt, compare: ==) else { return false }
    guard compareOptionals(lhs: lhs.dueOn, rhs: rhs.dueOn, compare: ==) else { return false }
    return true
}
// MARK: - GitHubPR AutoEquatable
extension GitHubPR: Equatable {}
public func == (lhs: GitHubPR, rhs: GitHubPR) -> Bool {
    guard lhs.number == rhs.number else { return false }
    guard lhs.title == rhs.title else { return false }
    guard lhs.body == rhs.body else { return false }
    guard lhs.user == rhs.user else { return false }
    guard compareOptionals(lhs: lhs.assignee, rhs: rhs.assignee, compare: ==) else { return false }
    guard compareOptionals(lhs: lhs.assignees, rhs: rhs.assignees, compare: ==) else { return false }
    guard lhs.createdAt == rhs.createdAt else { return false }
    guard lhs.updatedAt == rhs.updatedAt else { return false }
    guard compareOptionals(lhs: lhs.closedAt, rhs: rhs.closedAt, compare: ==) else { return false }
    guard compareOptionals(lhs: lhs.mergedAt, rhs: rhs.mergedAt, compare: ==) else { return false }
    guard lhs.head == rhs.head else { return false }
    guard lhs.base == rhs.base else { return false }
    guard lhs.state == rhs.state else { return false }
    guard lhs.isLocked == rhs.isLocked else { return false }
    guard compareOptionals(lhs: lhs.isMerged, rhs: rhs.isMerged, compare: ==) else { return false }
    guard compareOptionals(lhs: lhs.commitCount, rhs: rhs.commitCount, compare: ==) else { return false }
    guard compareOptionals(lhs: lhs.commentCount, rhs: rhs.commentCount, compare: ==) else { return false }
    guard compareOptionals(lhs: lhs.reviewCommentCount, rhs: rhs.reviewCommentCount, compare: ==) else { return false }
    guard compareOptionals(lhs: lhs.additions, rhs: rhs.additions, compare: ==) else { return false }
    guard compareOptionals(lhs: lhs.deletions, rhs: rhs.deletions, compare: ==) else { return false }
    guard compareOptionals(lhs: lhs.changedFiles, rhs: rhs.changedFiles, compare: ==) else { return false }
    guard compareOptionals(lhs: lhs.milestone, rhs: rhs.milestone, compare: ==) else { return false }
    return true
}
// MARK: - GitHubRepo AutoEquatable
extension GitHubRepo: Equatable {}
public func == (lhs: GitHubRepo, rhs: GitHubRepo) -> Bool {
    guard lhs.id == rhs.id else { return false }
    guard lhs.name == rhs.name else { return false }
    guard lhs.fullName == rhs.fullName else { return false }
    guard lhs.owner == rhs.owner else { return false }
    guard lhs.isPrivate == rhs.isPrivate else { return false }
    guard lhs.description == rhs.description else { return false }
    guard lhs.isFork == rhs.isFork else { return false }
    guard lhs.htmlURL == rhs.htmlURL else { return false }
    return true
}
// MARK: - GitHubRequestedReviewers AutoEquatable
extension GitHubRequestedReviewers: Equatable {}
public func == (lhs: GitHubRequestedReviewers, rhs: GitHubRequestedReviewers) -> Bool {
    guard lhs.users == rhs.users else { return false }
    guard lhs.teams == rhs.teams else { return false }
    return true
}
// MARK: - GitHubReview AutoEquatable
extension GitHubReview: Equatable {}
public func == (lhs: GitHubReview, rhs: GitHubReview) -> Bool {
    guard lhs.user == rhs.user else { return false }
    guard compareOptionals(lhs: lhs.id, rhs: rhs.id, compare: ==) else { return false }
    guard compareOptionals(lhs: lhs.body, rhs: rhs.body, compare: ==) else { return false }
    guard compareOptionals(lhs: lhs.commitId, rhs: rhs.commitId, compare: ==) else { return false }
    guard compareOptionals(lhs: lhs.state, rhs: rhs.state, compare: ==) else { return false }
    return true
}
// MARK: - GitHubTeam AutoEquatable
extension GitHubTeam: Equatable {}
public func == (lhs: GitHubTeam, rhs: GitHubTeam) -> Bool {
    guard lhs.id == rhs.id else { return false }
    guard lhs.name == rhs.name else { return false }
    return true
}
// MARK: - GitHubUser AutoEquatable
extension GitHubUser: Equatable {}
public func == (lhs: GitHubUser, rhs: GitHubUser) -> Bool {
    guard lhs.id == rhs.id else { return false }
    guard lhs.login == rhs.login else { return false }
    guard lhs.userType == rhs.userType else { return false }
    return true
}

// MARK: - AutoEquatable for Enums
