/*
CreatedBY Jignasha patel
Date 08 April 2024
Create Custom CSV file with header and data.
*/
public class CSVWriter1 {
    
    // METHOD TO CREATE CSV CONTENT
    public static String writeForVoicemail(List<String> headers, List<List<String>> data) {
        String csvContent = '';
        
        // HEADERS
        if(headers != null && headers.size() > 0){
            csvContent += escapeAndJoin(headers) + '\n';
        } 
        
        // DATA
        if(data != null && data.size() > 0){
            for(List<String> row : data) {
                csvContent += escapeAndJoin(row) + '\n';
            }
        }
        return csvContent;
    }
    
    // METHOD TO ESCAPE AND JOIN LIST ELEMENTS
    private static String escapeAndJoin(List<String> values) {
        
        List<String> escapedValues = new List<String>();
        
        if(values != null && values.size() > 0){
            for(String value : values) {
                value = '"' + value.replaceAll('"', '""') + '"';
                escapedValues.add(value);
            }
        }
        return String.join(escapedValues, ',');
    }
    
    // METHOD TO CREATE CSV CONTENT
    /* public static String write(List<String> headers, List<String> data) {
String csvContent = '';

// HEADERS
csvContent += escapeAndJoin(headers) + '\n';

// DATA
for(String row : data) {
csvContent += row + '\n';
}

return csvContent;
}*/
}