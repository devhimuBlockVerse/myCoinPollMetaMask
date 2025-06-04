
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
    answer: "You can check your ticket status by going to the Tickets section in your dashboard. Each ticket will show its status (Open, In Progress, Pending, Resolved, or Closed) along with the last update."
   ),
  FAQItemData(
    question: "Can I attach files to my ticket?",
    answer: "Yes! When submitting a ticket or replying to a response, you can attach files such as screenshots, invoices, or documents to help support agents understand your issue better."
   ),
  FAQItemData(
    question: "How long does it take to get a response?",
    answer: "Response times depend on the ticket priority level:\n"
        "• High Priority: Within 1 hour\n"
        "• Medium Priority: Within 4 hours\n"
        "• Low Priority: Within 24 hours",
  ),

  FAQItemData(
    question: "What happens if I close my ticket by mistake?",
    answer: "If you close your ticket accidentally and still need help, you can reopen it from your dashboard. If you can't reopen it, simply create a new ticket and mention your previous ticket ID."
   ),
];
