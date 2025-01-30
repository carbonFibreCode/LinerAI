class CloudStorageException implements Exception {
  const CloudStorageException();
}
//C in CRUD
class CouldNotCreateChatException extends CloudStorageException {}
//R in CRUD
class CouldNotGetAllChatsException extends CloudStorageException {}
//U in CRUD
class CouldNotUpdateChatsException extends CloudStorageException {}
//D in CRUD
class CouldNotDeleteChatseException extends CloudStorageException {}