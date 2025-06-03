class TicketListModel {
  final String ticketID;
  final String subject;
  final String date;
  final String status;

  TicketListModel({
    required this.ticketID,
    required this.subject,
    required this.date,
    required this.status,
  });

  factory TicketListModel.fromJson(Map<String, dynamic> json) {
    return TicketListModel(
      ticketID: json['TicketID'] ?? '',
      subject: json['Subject'] ?? '',
      date: json['Date'] ?? '',
      status: json['Status'] ?? '',
    );
  }
}
