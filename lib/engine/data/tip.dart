class Info {
  String title = "";
  String content = "";
  InfoType type = InfoType.rule;
  Info(this.title, this.content, this.type);
}

enum InfoType { rule, alert, tip, setting }
