class AppUrl{
//  static const String baseUrl ="http://192.168.16.104:8000/api/";
  static const String baseUrl ="http://192.168.16.102:8000/api/";
  static const String imageUrl ="http://192.168.16.104:8000/storage/"; 

  static const String registrationUri ="${baseUrl}auth/register";
  static const String loginUri ="${baseUrl}auth/login";
  static const String userUri ="auth/me";
  //jobs
  static const String allJobsUri ='${baseUrl}auth/all-jobs';
  static const String addJobUri ='${baseUrl}auth/add-job';
  static const String updateJobUri ='${baseUrl}auth/update-job';
  static const String deleteJobUri ='${baseUrl}auth/delete-job';
  static const String allCountriesUri ='${baseUrl}auth/all-countries';
  static const String stateFromCountryUri ='${baseUrl}auth/country-wise-state';
  static const String cityFromStateUri ='${baseUrl}auth/state-wise-city';
  
 
}
