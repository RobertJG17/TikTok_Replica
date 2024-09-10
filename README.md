#  Tik Tok Tutorial Project

### Project Progress
Essential Features: (85%)

## API Layer - Managed Backend with Firebase
### Implementation Details
We created a one to one association between our service and model layer to isolate data fetching needs as much as possible.
Pattern:

fetchUserInformation (Service) -> setupUserInformationPropertyObserver (Service) (users collection)
fetchUserMetadata (Service) -> setupUserMetadataPropertyObserver (Service)       (user stats collection)
fetchUserPostdata (Service) -> setupUserPostdataPropertyObserver (Service)       (user posts collection) 

With related data associated by FUID (Firestore unique id)

Found these custom #pragma marks thru stackoverflow [thread]("https://stackoverflow.com/questions/6662395/xcode-intellisense-meaning-of-letters-in-colored-boxes-like-f-t-c-m-p-c-k-etc")
MARK: also explains xcode's icon labeling with code sense
    
### View Components 

- [x] Feed View
- [x] Friends View
- [x] Notifications View
- [x] Profile View
- [X] Login View
- [X] Registration View

<br/>

### Future feature updates
- [x] Develop video player functionality to play uploaded/shared content.
- [x] Develop Firebase authentication scheme
- [x] Develop Routing Logic and manage Firebase session securely
- [x] Develop Service layer to interact with collections within Firebase
- [ ] Firestore storage for user posts.
