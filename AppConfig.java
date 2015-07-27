import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.PreparedStatement;

class AppConfig {

	private static String dbUrl = "jdbc:mysql://127.0.0.1:3306/apisrv";
	private static String dbUsername = "apisrv";
	private static String dbPassword = "apisrv";

	private Connection connection = null;

	private void dbConnect() {
		if(connection == null) {
			try {
				Class.forName("com.mysql.jdbc.Driver").newInstance();
				connection = DriverManager.getConnection(dbUrl, dbUsername, dbPassword);
			} catch(SQLException e) {
		    	System.err.print(e.getMessage());
			} catch(Exception e) {
		    	System.err.print(e.getMessage());
			}
		}
	}

	public String showSchema(String schemaName) {
		String json="";
		dbConnect();
		if(connection != null) {
			try {
				String query="select id,name,array_name from apisrv_schema_group where name=?;";
            	PreparedStatement preparedStatement = connection.prepareStatement(query);
            	preparedStatement.setString(1,schemaName);
            	ResultSet resultSet=preparedStatement.executeQuery();
				for(int i=0; resultSet.next(); i++) {
					int            id = resultSet.getInt   ("id");
					String       name = resultSet.getString("name");
					String array_name = resultSet.getString("array_name");
					System.out.println("id: "+id+" - name: "+name+" - array_name: "+array_name);
					if(i>0) json+=",";
					json+="{ \""+name+"\": ";
					if(array_name != null) json+="[ { \""+array_name+"\": [";
					// Determine sub-groups
					String query_sub="select schema_key,(select name from apisrv_schema_group where id=group_ref) group_name from apisrv_group_keys where group_id=? order by seq_num asc;";
					PreparedStatement preparedStatement_sub = connection.prepareStatement(query_sub);
					preparedStatement_sub.setInt(1,id);
				    ResultSet resultSet_sub=preparedStatement_sub.executeQuery();
					boolean skipClosure=false;
					for(int j=0; resultSet_sub.next(); j++) {
						String schema_key = resultSet_sub.getString("schema_key");
						String group_name = resultSet_sub.getString("group_name");
						System.out.println("  schema_key: "+schema_key+" - group_name: "+group_name);
						if(j>0) json += ",";
						if(group_name == null) {
							if(j==0) json +="{";
							json +=" \""+schema_key+"\": \"\"";
						}
						else { skipClosure=true; json+=showSchema(group_name); }
					}
					if(!skipClosure) json +="}";
					if(array_name != null) json+="]}]";
					json +="}";
            	}
			} catch(SQLException e) {
				System.err.print(e.getMessage());
       		} catch(Exception e) {
           		System.err.print(e); 
        	}
		}
		return json;
	}


	public static void main(String args[]) {
			AppConfig appConfig = new AppConfig();
		  //System.out.println(appConfig.showSchema("rOCCI-infrastructure"));
			System.out.println(appConfig.showSchema("EMIGrid-infrastructure"));
	}
}


