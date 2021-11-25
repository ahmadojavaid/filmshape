import 'package:intl/intl.dart';

const double INPUT_BOX_BORDER_WIDTH = 1;
const double ITEM_DIVIDER = 0.5;
const String SELECT_IMAGE_MESSAGE = "Please select Image.";
const String NO_NETWORK_MESSAGE = "Please check your Internet connection!";
const String CONTACT_SYNCED_MESSAGE = "Contact synced successfully";
const String USER_BLOCKED_MESSAGE = "User blocked successfully";
const String USER_UNBLOCKED_MESSAGE = "User Unblocked successfully";
const String USER_BLOCKED_ALERT_MESSAGE =
    "User is blocked unblock to send message";

const String GALLARY = "Choose Photo";
const String CAMERA = "Take Photo";
const String CANCEL = "Cancel";
const String FCM_DEVICE_TOKEN = "fcm_device_token";
const String DEVICES = "devices";

//for profile and cover pic
const String STORAGE_USER = "users";
const String STORAGE_PROFILE = "profile";
const String STORAGE_GAME_COVER = "gamecover";
const String STORAGE_THUMBS = "thumbs";

const String NO_COVER_IMAGE_FOUND =
    "assets/images/placeholder_cover_image.webp";

//for facebook and google preferred image size
const int FB_G_PHOTO_SIZE = 400;
const int FB_G_LARGE_PHOTO_SIZE = 1000;
const String G_IMAGE_URL_PREFIX = "lh3.googleusercontent.com";
const String FB_IMAGE_URL_PREFIX = "graph.facebook.com";

//const double PIC_IMAGE_WIDTH_HEIGHT = 1200;
const double LOAD_MORE_OFFSET = 1200;
const int PAGINATION_SIZE = 5;

//image size
const double maxWidth = 400;
const double maxHeight = 400;
const double MARGIN_LEFT_RIGHT = 40;
const double MARGIN_FROM_LOGO_TOP=40;
const double MARGIN_FOR_INPUT_FIELD=50;
const double BUTTON_TOP_MARGIN=60; //forget and login screen

//bottom sheet
const double BOTTOMSHEET_MARGIN_LEFT_RIGHT = 30;

//for TextFormField
const double TextFormField_Veritical_Margin=18;
const double TextFormField_Horizontal_Margin=15;

const double SELECT_TAB_ICON_SIZE=25;
const double UNSELECT_TAB_ICON_SIZE=23;
const double LOADER_RADIUS = 15;

enum PROJECTTYPE {
  ALL,
  TOPRATED,
  FEATURED,
  MOSTVIEWED
}

enum REQUESTTYPE {
  ACCEPT,
  REJECT,
  DELETE
}

enum LOADROLEICONFROM {
  LOCAL,
  SERVER,

}

enum TUTORIALSTATE {
  NONE,
  HOME,
  PROJECTSETTINGS

}



//provide paypal email
const String PAYPALEMAIL =
    "Please edit your profile and provide your valid PayPal email for payment process before posting the game. Please make sure don't provide any fake and hacked game accounts otherwise you will be banned.";
const String PAYPALEMAILALERT =
    "Account Dealer required to provide your valid paypal email. Which will be used to send you payment through pay. Once your game is purchsed by someone. Make sure it should be valid paypal email!";
const String DELETE_PHOTO = "Delete Photo";

//navigation drawer contanst
const double PROFILE_IMAGE_W_H = 80;
const double ICON_LEFT_PADDING = 0;

const double LIST_PLAYER_HEIGHT = 320;

//load more
const int RESULT_PER_PAGE = 20;
//free account role selection

const int ROLE_SELECT_COUNT_CHECK = 10;

const double TABS_LEFT_MARGIN = 20;

//dashboard header
const String community="Community";

//view tab bar item height
const double TAB_ITEM_HEIGHT = 280;

//tab bar const
const INVITENREQUEST="Invites & Requests";

const browseAllProjects="Browse all projects";

//date format for diff screen
//notification screen
const notiDateFormat="dd/MM/yyyy";

//firebase properties
const String FIREBASE_USER_PASSWORD="filmshape";

const String lorumIpsum="Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum";

//notifier text
const String ACCOUNT_UPGRADED_NOTIFIER="usertype";

final DateOfBirthformat = DateFormat("yyyy-MM-dd");