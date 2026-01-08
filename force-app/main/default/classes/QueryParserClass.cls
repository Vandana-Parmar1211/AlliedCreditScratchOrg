//THIS CLASS IS USED IN TRIGGER FOR PARSING THE FILTER CRITERIA OF QUERY FIELD OF ACTIVE SCHEDULE OBJECT
global with sharing class QueryParserClass {
    
    //METHOD THAT RETURNS MAP OF FIELD AND IT'S VALUE OF FILTER CRITERIA FROM QUERY FIELD
    global static Map<String, String> getWhereClauseFieldsAndItsValues(String queryString) {
        
        List<String> conditions = new List<String>();
        map<string , string> mapofvalues = new  map<string , string>();
        
        // SPLIT THE WHERE CALUSE INTO CONDITIONS (ASSUMING SIMPLE CONDITIONS SEPARATED BY AND)
        if( queryString != null && queryString != '') {
            
            for (String condition : queryString.split('AND')) {
                conditions.add(condition.trim());
            }
            
            if(conditions != null && conditions.size() > 0) {
                
                for (String condition : conditions) {
                    condition = condition.trim();
                    String[] parts;
                    if( condition != null && condition != ''){
                         system.debug('@@condition-->'+condition);
                        //parts = condition.split('\\s*(<|>|!=|>=|<=)\\s*');
                        if(condition.Contains('!=')){
                           parts = condition.split('!='); 
                            
                        }else if(condition.Contains('>=')){
                            parts = condition.split('>=');
                            
                        }else if(condition.Contains('<=')){
                             parts = condition.split('<=');
                            
                        }else if(condition.Contains('<')){
                            parts = condition.split('<');
                            
                        } else if(condition.Contains('>')){
                            parts = condition.split('>');
                            
                        } else if(condition.Contains('=')){
                            parts = condition.split('=');
                        }  
                        system.debug('@@parts-->'+parts);
                        if (parts.size() == 2) {
                            
                            String field = parts[0].trim();
                            String value = parts[1].trim();
                            
                            if (condition.contains('!=')) {
         					   value = '#!=#' + value;
      						 
                            }else if (condition.contains('<=')) {
         					   value = '#<=#' + value;
      						
                            }else if (condition.contains('>=')) {
         					   value = '#>=#' + value;
                                
      						 }else if (condition.contains('>')) {
         					   value = '#>#' + value;
                                 
      						 }else if (condition.contains('<')) {
         					   value = '#<#' + value;
      						  }
                            // REMOVE ANY SURROUNDING QUOTES FROM THE VALUE
                            if (value.startsWith('\'') && value.endsWith('\'')) {
                                value = value.substring(1, value.length() - 1);
                            }
                            mapofvalues.put(Field,Value);
                        }
                    }
                }   
            }
        } 
        system.debug('@@mapofvalues-->'+mapofvalues);
        return mapofvalues;
    }
    
    //METHOD THAT SPLITS WHERE CONDITION FROM QUERY FIELD
    global static String getwhereclause(String queryString) {
        
        String whereClause;
        Integer whereIndex;
        // Extract the WHERE clause
        if(queryString != null && queryString != ''){
            whereIndex = queryString.indexOf('WHERE'); 
            
            if (whereIndex == -1) {
                return whereClause; // No WHERE clause found
            }
            whereClause = queryString.substring(whereIndex + 5).trim();
            
            // Remove any trailing semicolon
            if (whereClause.endsWith(';')) {
                whereClause = whereClause.substring(0, whereClause.length() - 1);
            }
            
            // Remove any trailing bracket
            if (whereClause.endsWith(']')) {
                whereClause = whereClause.substring(0, whereClause.length() - 1).trim();
            }
        } 
        return whereClause;        
    }
    
     //METHOD THAT RETURNS MAP OF FIELD AND IT'S VALUE OF FILTER CRITERIA FROM QUERY FIELD
    global static Map<String, String> getWhereClauseFieldsAndItsValuesForAllOp(String queryString) {
        
        List<String> conditions = new List<String>();
        map<string , string> mapofvalues = new  map<string , string>();
        
        // SPLIT THE WHERE CALUSE INTO CONDITIONS (ASSUMING SIMPLE CONDITIONS SEPARATED BY AND)
        if( queryString != null && queryString != '') {
            
            for (String condition : queryString.split('AND')) {
                conditions.add(condition.trim());
            }
            
            if(conditions != null && conditions.size() > 0) {
                
                for (String condition : conditions) {
                    condition = condition.trim();
                    String[] parts;
                    if( condition != null && condition != ''){
                         system.debug('@@condition-->'+condition);
                        //parts = condition.split('\\s*(<|>|!=|>=|<=)\\s*');
                        if(condition.Contains('!=')){
                           parts = condition.split('!='); 
                            
                        }else if(condition.Contains('>=')){
                            parts = condition.split('>=');
                            
                        }else if(condition.Contains('<=')){
                             parts = condition.split('<=');
                            
                        }else if(condition.Contains('<')){
                            parts = condition.split('<');
                            
                        } else if(condition.Contains('>')){
                            parts = condition.split('>');
                            
                        } else if(condition.Contains('=')){
                            parts = condition.split('=');
                        }  
                        system.debug('@@parts-->'+parts);
                        if (parts.size() == 2) {
                            
                            String field = parts[0].trim();
                            String value = parts[1].trim();
                            
                            if (condition.contains('!=')) {
         					   value = '#!=#' + value;
      						 
                            }else if (condition.contains('<=')) {
         					   value = '#<=#' + value;
      						
                            }else if (condition.contains('>=')) {
         					   value = '#>=#' + value;
                                
      						 }else if (condition.contains('>')) {
         					   value = '#>#' + value;
                                 
      						 }else if (condition.contains('<')) {
         					   value = '#<#' + value;
                                 
      						  }else if (condition.contains('=')) {
         					   value = '#=#' + value;
      						  }
                            // REMOVE ANY SURROUNDING QUOTES FROM THE VALUE
                            if (value.startsWith('\'') && value.endsWith('\'')) {
                                value = value.substring(1, value.length() - 1);
                            }
                            mapofvalues.put(Field,Value);
                        }
                    }
                }   
            }
        } 
        system.debug('@@mapofvalues-->'+mapofvalues);
        return mapofvalues;
    }
    
    
    
    
}