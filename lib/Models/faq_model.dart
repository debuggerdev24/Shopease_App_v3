class FaqModel {
  String question;
  String answer;

  FaqModel({
    required this.question,
    required this.answer,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) => FaqModel(
        question: json["question"],
        answer: json["answer"],
      );

  Map<String, dynamic> toJson() => {
        "question": question,
        "answer": answer,
      };
}

final List<FaqModel> dummyFaqs = [
  FaqModel(
    question: "What is Shopease app?",
    answer:
        "Lorem Ipsum available, but the majority have suffered alteration in some form. Lorem Ipsum available, but the majority have suffered alteration",
  ),
  FaqModel(
    question: "What is Shopease app?",
    answer:
        "Lorem Ipsum available, but the majority have suffered alteration in some form. Lorem Ipsum available, but the majority have suffered alteration",
  ),
  FaqModel(
    question: "What is Shopease app?",
    answer:
        "Lorem Ipsum available, but the majority have suffered alteration in some form. Lorem Ipsum available, but the majority have suffered alteration",
  ),
  FaqModel(
    question: "What is Shopease app?",
    answer:
        "Lorem Ipsum available, but the majority have suffered alteration in some form. Lorem Ipsum available, but the majority have suffered alteration",
  ),
  FaqModel(
    question: "What is Shopease app?",
    answer:
        "Lorem Ipsum available, but the majority have suffered alteration in some form. Lorem Ipsum available, but the majority have suffered alteration",
  ),
  FaqModel(
    question: "What is Shopease app?",
    answer:
        "Lorem Ipsum available, but the majority have suffered alteration in some form. Lorem Ipsum available, but the majority have suffered alteration",
  ),
  FaqModel(
    question: "What is Shopease app?",
    answer:
        "Lorem Ipsum available, but the majority have suffered alteration in some form. Lorem Ipsum available, but the majority have suffered alteration",
  ),
];
