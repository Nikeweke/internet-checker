class DateService {
  static String getJournalDateNow() {
    DateTime today = new DateTime.now();
    return today.year.toString() + '-' +
      today.month.toString() + '-' +
      today.day.toString().padLeft(2,'0') + '-' +
      today.hour.toString() + ':' + 
      today.minute.toString() + ':' + 
      today.second.toString();
  }
}