public class EventWaitingRoomController {
    public class DateWrapper {
        @InvocableVariable
        public String formattedDate;
    }

    @InvocableMethod(label='Get Current Date' description='Returns the current date in dd/MM/yyyy format')
    public static List<DateWrapper> getCurrentDateFormatted(List<String> requests) {
        // Get the user's timezone
        TimeZone tz = UserInfo.getTimeZone();
        
        // Get the current date and time in the user's timezone
        DateTime now = DateTime.now();
        DateTime localNow = now.addSeconds(tz.getOffset(now) / 1000);
        
        // Format the current date as dd/MM/yyyy
        String formattedDate = localNow.format('dd/MM/yyyy', tz.getId());
        
        // Wrap the formatted date in the custom wrapper class
        DateWrapper wrapper = new DateWrapper();
        wrapper.formattedDate = formattedDate;
        
        // Return the wrapped date
        return new List<DateWrapper>{wrapper};
    }
}