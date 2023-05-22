class AppUrl{
 
  static const String baseUrl ="http://192.168.16.104:8000/api/";
  static const String imageUrl ="http://192.168.16.104:8000/storage/"; 

  static const String registrationUri ="${baseUrl}auth/register";
  static const String loginUri ="${baseUrl}auth/login";
  static const String userUri ="auth/me";
  //jobs
  static const String allJobsUri ='${baseUrl}auth/all-jobs';
  static const String addJobUri ='${baseUrl}auth/add-job';
 
}
