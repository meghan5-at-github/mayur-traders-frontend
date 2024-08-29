class ApiUrls {
  static const baseUrl = 'http://localhost:3000/api/';
  static const addUserUrl = '${baseUrl}user/add_user';
  static const getUserUrl = '${baseUrl}user/get_user';
  static const updateUserUrl = '${baseUrl}user/update_user';
  static const deleteUserUrl = '${baseUrl}user/delete_user';

  static String profileToken="";

  static bool loaderOnBtn=false;
}
