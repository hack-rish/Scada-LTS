package org.scada_lts.dao.migration.mysql;

import org.flywaydb.core.api.migration.BaseJavaMigration;
import org.flywaydb.core.api.migration.Context;
import org.scada_lts.dao.DAO;
import org.springframework.jdbc.core.JdbcTemplate;

public class V1_2__SetViewSizeProperties extends BaseJavaMigration {

    @Override
	public void migrate(Context context) throws Exception {
		/*
System.out.println("//////////////////////////////////////////////////////////////////////////////////");
System.out.println("//////////////////////////////////////////////////////////////////////////////////");
	
System.out.println("//////////////////////////////////////////////////////////////////////////////////");
System.out.println("//////////////////////////////////////////////////////////////////////////////////");
System.out.println("//////////////////////////////////////////////////////////////////////////////////");
System.out.println("//////////////////////////////////////////////////////////////////////////////////");
System.out.println("//////////////////////////////////////////////////////////////////////////////////");
System.out.println("//////////////////////////////////////////////////////////////////////////////////");
System.out.println("//////////////////////////////////////////////////////////////////////////////////");
System.out.println("//////////////////////////////////////////////////////////////////////////////////");
System.out.println("//////////////////////////////////////////////////////////////////////////////////");
System.out.println("//////////////////////////////////////////////////////////////////////////////////");
System.out.println("//////////////////////////////////////////////////////////////////////////////////");
System.out.println("//////////////////////////////////////////////////////////////////////////////////");
System.out.println("ALTER TABLE");

System.out.println("//////////////////////////////////////////////////////////////////////////////////");
System.out.println("//////////////////////////////////////////////////////////////////////////////////");
System.out.println("//////////////////////////////////////////////////////////////////////////////////");
System.out.println("//////////////////////////////////////////////////////////////////////////////////");
System.out.println("//////////////////////////////////////////////////////////////////////////////////");
System.out.println("//////////////////////////////////////////////////////////////////////////////////");
System.out.println("//////////////////////////////////////////////////////////////////////////////////");
System.out.println("//////////////////////////////////////////////////////////////////////////////////");
System.out.println("//////////////////////////////////////////////////////////////////////////////////");
System.out.println("//////////////////////////////////////////////////////////////////////////////////");
System.out.println("//////////////////////////////////////////////////////////////////////////////////");
System.out.println("//////////////////////////////////////////////////////////////////////////////////");
System.out.println("//////////////////////////////////////////////////////////////////////////////////");
System.out.println("//////////////////////////////////////////////////////////////////////////////////");
System.out.println("//////////////////////////////////////////////////////////////////////////////////");

	*/
	
		final JdbcTemplate jdbcTmp = DAO.getInstance().getJdbcTemp();

		final String setViewSizeProperties = ""
	    		+ "alter table mangoViews " +
					"add column `width` int after `data`,"+
					"add column `height` int after `width`,"+
					"add column `mapData` longblob after `height`";
			
		
		//TODO migrate on existing views and set not null for width and height.
		
		jdbcTmp.execute(setViewSizeProperties);
	}

}
