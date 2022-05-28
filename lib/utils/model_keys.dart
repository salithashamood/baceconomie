class CommonKeys {
  static String id = 'id';
  static String createdAt = 'createdAt';
  static String updatedAt = 'updatedAt';
}

class UserKeys {
  static String email = 'email';
  static String password = 'password';
  static String name = 'name';
  static String age = 'age';
  static String points = 'points';
  static String loginType = 'loginType';
  static String photoUrl = 'photoUrl';
  static String isAdmin = 'isAdmin';
  static String isNotificationOn = 'isNotificationOn';
  static String themeIndex = 'themeIndex';
  static String appLanguage = 'appLanguage';
  static String oneSignalPlayerId = 'oneSignalPlayerId';
  static String isSuperAdmin = 'isSuperAdmin';
  static String isTestUser = 'isTestUser';
}

class QuizKeys {
  static String categoryId = 'categoryId';
  static String categoryName = 'categoryName';
  static String imageUrl = 'imageUrl';
  static String minRequiredPoint = 'minRequiredPoint';
  static String questionRef = 'questionRef';
  static String questions = 'questions';
  static String quizTitle = 'quizTitle';
  static String description = 'description';
  static String quizTime = 'quizTime';
  static String onlineQuizCode = 'onlineQuizCode';
  static String expireQuizStatus = 'expireQuizStatus';
  static String subcategoryId = 'subcategoryId';
}

class AppSettingKeys {
  static String disableAd = 'disableAd';
  static String termCondition = 'termCondition';
  static String privacyPolicy = 'privacyPolicy';
  static String contactInfo = 'contactInfo';
}

class QuestionTypeKeys {
  static String trueFalse = 'True false';
  static String options = 'Option';
}

class QuestionKeys {
  static String addQuestion = 'addQuestion';
  static String correctAnswer = 'correctAnswer';
  static String optionList = 'optionList';
  static String category = 'name';
  static String questionType = 'questionType';
  static String note = 'note';
  static String subcategoryId = 'subcategoryId';
}

class NewsKeys {
  static String commentCount = 'commentCount';
  static String content = 'content';
  static String shortContent = 'shortContent';
  static String thumbnail = 'thumbnail';
  static String sourceUrl = 'sourceUrl';
  static String image = 'image';
  static String newsStatus = 'newsStatus';
  static String postViewCount = 'postViewCount';
  static String title = 'title';
  static String newsType = 'newsType';
  static String allowComments = 'allowComments';
  static String categoryRef = 'category';
  static String authorRef = 'authorRef';
  static String caseSearch = 'caseSearch';
}

class QuestionTimeKeys {
  static String questionTime = 'questionTime';
}

class CategoryKeys {
  static String name = 'name';
  static String image = 'image';
  static String parentCategoryId = 'parentCategoryId';
}

class QuizHistoryKeys {
  static String userId = 'userId';
  static String quizAnswers = 'quizAnswers';
  static String quizTitle = 'quizTitle';
  static String image = 'image';
  static String quizType = 'quizType';
  static String totalQuestion = 'totalQuestion';
  static String rightQuestion = 'rightQuestion';
}

class QuizAnswerKeys {
  static String question = 'question';
  static String answers = 'answers';
  static String correctAnswer = 'correctAnswer';
}
