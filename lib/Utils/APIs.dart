class APIs {
  APIs._();

  // Base url for testing
   static const String baseUrl = "http://35.226.88.58/api";
 // static const String baseUrl = "http://filmshape.pythonanywhere.com/api";
  static const String imageBaseUrl = "http://35.226.88.58";

  //new App Url
  static const String signUpUrl = "$baseUrl/auth/register/";
  static const String forgotUrl = "$baseUrl/auth/reset-password/";
  static const String changePassword = "$baseUrl/auth/set-password/";
  static const String loginUrl = "$baseUrl/auth/token/";
  static const String feedUrl = "$baseUrl/feed/?page=";
  static const String genderUrl = "$baseUrl/entity/Gender/";
  static const String commonDataJoin = "$baseUrl/entity/";
  static const String ehicityUrl = "$baseUrl/entity/Ethnicity/";
  static const String createProfileUrl = "$baseUrl/entity/User/";
  static const String createProjectUrl = "$baseUrl/entity/Project/";
  static const String getProjectUrl = "$baseUrl/entity/Project/";
  static const String searchTalent = "$baseUrl/entity/User/";
  static const String searchProjects = "$baseUrl/entity/Project/search/";
  static const String myProjects = "$baseUrl/entity/Project/";
  static const String browseProjects = "$baseUrl/entity/Project/all";


  static const String addRoleTab = "$baseUrl/entity/RoleCall/";
  static const String getThreadComment = "$baseUrl/entity/Comment/";

  static const String removeRoleTab = "$baseUrl/entity/RoleCall/";
  static const String hideSalary = "$baseUrl/entity/Project/";
  static const String unassignToSelf = "$baseUrl/entity/RoleCall/";

  static const String updateUserShowReelUrl = "$baseUrl/entity/Showreel/";
  static const String rolesUrl = "$baseUrl/roles/";
  static const String searchProjectUrl = "$baseUrl/entity/Project/search";
  static const String suggestionUserUrl = "$baseUrl/suggestions/";
  static const String userSuggestionFollow = "$baseUrl/entity/User/";
  static const String likeUnlikeProject = "$baseUrl/entity/Project/";

  static const String likeUnlikeProjectFeed = "$baseUrl/entity/";
  static const String getmyProfile = "$baseUrl/entity/User/";
  static const String getChannelId = "https://www.googleapis.com/youtube/v3/channels?part=id&mine=true&access_token=";

  //vimeo api
  static const String getVimeoToken = "https://api.vimeo.com/oauth/access_token";
  static const String getVimeoVideosList = "https://api.vimeo.com/me/videos";

  static const String comments = "$baseUrl/entity/";
  static const String awards = "$baseUrl/entity/Award/";
  static const String inviteSend = "$baseUrl/entity/RoleCall/";
  static const String search = "$baseUrl/search/?q=";
  static const String notification = "$baseUrl/entity/User/notifications/?per_page=";
  static const String sendinvite = "$baseUrl/entity/User/requests/";
  static const String acceptreject = "$baseUrl/entity/Request/";
  static const String applyForRole = "$baseUrl/entity/Request/";
  static const String deleteProfile = "$baseUrl/entity/User/";
  static const String hideProfile = "$baseUrl/entity/User/hide/";
  static const String hideCredits = "$baseUrl/entity/RoleCall/";
  static const String assignUserToProject = "$baseUrl/entity/RoleCall";

  //youtube token url

static const String youtubeTokenUrl="https://accounts.google.com/o/oauth2/token";



}
