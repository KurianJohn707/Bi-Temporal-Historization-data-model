function Mytable()

{

    var query = "{CALL 'BI-TEMPORAL_HISTORIZATION'.'gbi-student-007.Bi-Temporal_Historization::main'()}";
    
    $.trace.debug(query);
    
    var conn = $.db.getConnection();
    
    var pcall = conn.prepareCall(query);
    
    pcall.execute();
    
    pcall.close();
    
    conn.commit();
    
    conn.close();

}


