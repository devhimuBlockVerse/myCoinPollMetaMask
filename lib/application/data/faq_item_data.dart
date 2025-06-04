
class FAQItemData {
  final String question;
  final String answer;

  FAQItemData({required this.question, required this.answer});
}

final List<FAQItemData> faqList = [
  FAQItemData(
    question: "How do I create a support ticket?",
    answer:
    "To create a support ticket, go to your User Dashboard, click \"Create New Ticket\", fill in the required details (subject, description, priority).",
  ),
  FAQItemData(
    question: "How can I check the status of my ticket?",
    answer:
    "You can check the status of your ticket by logging into your account and navigating to the 'My Tickets' section. The status will be displayed next to each ticket.",
  ),
  FAQItemData(
    question: "Can I attach files to my ticket?",
    answer:
    "Yes, you can attach files to your support ticket. When creating or replying to a ticket, look for an 'Attach File' button or a paperclip icon. Supported file types and size limits may apply.",
  ),
  FAQItemData(
    question: "What is the typical response time for a ticket?",
    answer:
    "Our typical response time is within 24 business hours. However, this can vary depending on the complexity of the issue and the current volume of requests. Critical issues are prioritized.",
  ),
  FAQItemData(
    question: "How do I reset my password?",
    answer:
    "To reset your password, click on the 'Forgot Password?' link on the login page. Enter your registered email address, and we'll send you instructions on how to create a new password.",
  ),
];
