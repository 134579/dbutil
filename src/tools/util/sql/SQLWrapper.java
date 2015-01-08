package tools.util.sql;

import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;

import tools.util.ExactLocation;
import tools.util.Location;
import tools.util.RetValue;

/**
 * @author Administrator
 * 
 */
public class SQLWrapper {
	/*
	 * public String dburl =
	 * "jdbc:sqlserver://127.0.0.1:1433;DatabaseName=Eagle";
	 * 
	 * public String username = "huangkai"; public String password = "123456";
	 * public String dbname = "WCMMetaTablejgml";
	 */

	/*
	 * public String dburl = "jdbc:mysql://10.214.52.132:3306/test"; public
	 * String username = "zhouyu"; public String password = "zhouyu"; public
	 * String dbname = "WCMMetaTablejgml";
	 */

	public String dbTypeString;
	public String dburl_ip;
	public String dburl_port;
	public String dburl_schema;

	public String dburl = "jdbc:oracle:thin:@10.214.52.132:1521:orcl";
	public String username = "canlian";
	public String password = "canlian";
	public String dbname = "wcmmetatablejgml";

	public int nbline = 20;

	public static boolean meaningLess(String s) {
		return s == null || s.length() == 0 || s.equalsIgnoreCase("null");
	}

	public static boolean isNUll(String s) {
		return s == null;
	}

	public static boolean isEmpty(String s) {
		return s != null && s.length() == 0;
	}

	public enum DbType {
		sqlserver, mysql, oracle
	}

	DbType dbType;
	String driver;

	public SQLWrapper(String dbTypeString, String dburl_ip, String dburl_port,
			String dburl_schema, String dbname, String username,
			String password, int nbline) {
		if (dbTypeString.equals("sqlserver")) {
			dburl = String.format("jdbc:sqlserver://%s:%s;DatabaseName=%s",
					dburl_ip, dburl_port, dburl_schema);
		} else if (dbTypeString.equals("mysql")) {
			dburl = String.format("jdbc:mysql://%s:%s/%s", dburl_ip,
					dburl_port, dburl_schema);
		} else {
			dburl = String.format("jdbc:oracle:thin:@%s:%s:%s", dburl_ip,
					dburl_port, dburl_schema);
		}
		this.dbTypeString = dbTypeString;
		this.dburl_ip = dburl_ip;
		this.dburl_port = dburl_port;
		this.dburl_schema = dburl_schema;

		this.username = username;
		this.password = password;
		this.dbname = dbname.toUpperCase();
		this.nbline = nbline;
		initilize();
	}

	public SQLWrapper() {
		dbname = dbname.toUpperCase();
		initilize();
	}

	public void initilize() {
		if (dburl.contains("sqlserver")) {
			dbType = DbType.sqlserver;
			driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
		}
		if (dburl.contains("mysql")) {
			dbType = DbType.mysql;
			driver = "com.mysql.jdbc.Driver";
		}
		if (dburl.contains("oracle")) {
			dbType = DbType.oracle;
			driver = "oracle.jdbc.driver.OracleDriver";
		}
	}

	public void testConnection() throws ClassNotFoundException, SQLException {
		executeQuery(selectAll(dbname), 10);
	}

	public static ArrayList<ArrayList<String>> resultSetToString(
			ResultSet resultSet, int n) throws Exception {
		ArrayList<String> col_name = new ArrayList<String>();
		ArrayList<ArrayList<String>> result = new ArrayList<ArrayList<String>>();
		ResultSetMetaData metaData = resultSet.getMetaData();
		int col_num = metaData.getColumnCount();
		for (int i = 1; i <= col_num; i++)
			col_name.add(metaData.getColumnLabel(i));
		result.add(col_name);

		while (resultSet.next() && n-- > 0) {
			ArrayList<String> cur_col = new ArrayList<String>();
			for (int i = 1; i <= col_num; i++)
				cur_col.add(resultSet.getString(i));
			result.add(cur_col);
		}
		return result;
	}

	public String selectAll(String dbname) throws ClassNotFoundException,
			SQLException {

		ArrayList<String> columnList = getColumnList(dbname);
		if (dbType == DbType.mysql || dbType == DbType.sqlserver
				|| columnList.size() == 0) {
			return "select * from " + dbname;
		}
		String sql = "select ";
		sql = sql + columnList.get(0);
		for (int i = 1; i < columnList.size(); i++) {
			sql = sql + "," + columnList.get(i);
		}
		sql = sql + " from " + dbname;
		return sql;

	}

	/**
	 * return result of given sql statement, at most n lines including header
	 * 
	 * @param sql
	 * @param n
	 * @return
	 * @throws Exception
	 */
	public ArrayList<ArrayList<String>> executeQuery(String sql, int n)
			throws SQLException, ClassNotFoundException {
		Connection connection = null;
		Statement statement = null;
		ResultSet resultSet = null;

		ArrayList<ArrayList<String>> result = new ArrayList<ArrayList<String>>();
		try {
			Class.forName(driver);
			connection = DriverManager.getConnection(dburl, username, password);
			statement = connection.createStatement(ResultSet.TYPE_FORWARD_ONLY,
					ResultSet.CONCUR_UPDATABLE);

			resultSet = statement.executeQuery(sql);
			ResultSetMetaData metaData = resultSet.getMetaData();

			ArrayList<String> col_name = new ArrayList<String>();
			int col_num = metaData.getColumnCount();
			for (int i = 1; i <= col_num; i++)
				col_name.add(metaData.getColumnLabel(i));
			result.add(col_name);

			while (resultSet.next() && n-- > 0) {
				ArrayList<String> cur_col = new ArrayList<String>();
				for (int i = 1; i <= col_num; i++)
					cur_col.add(resultSet.getString(i));
				result.add(cur_col);
			}
			return result;
		} catch (SQLException e) {
			e.printStackTrace();
			throw e;
		} finally {
			quitQuietly(connection, statement, resultSet);
		}
	}

	public ArrayList<String> getColumnList(String dbname)
			throws ClassNotFoundException, SQLException {
		ArrayList<ArrayList<String>> result = executeQuery("select * from "
				+ dbname, 5);
		return result.get(0);
	}

	public int getRowCount() throws ClassNotFoundException, SQLException {
		ArrayList<ArrayList<String>> result = executeQuery(
				"select count(*) from " + dbname, Integer.MAX_VALUE);
		return Integer.parseInt(result.get(1).get(0));
	}

	public int executeUpdate(String sql) throws SQLException,
			ClassNotFoundException {
		Connection connection = null;
		Statement statement = null;
		ResultSet resultSet = null;
		try {
			Class.forName(driver);
			connection = DriverManager.getConnection(dburl, username, password);
			statement = connection.createStatement(ResultSet.TYPE_FORWARD_ONLY,
					ResultSet.CONCUR_UPDATABLE);
			return statement.executeUpdate(sql);
		} catch (SQLException e) {
			e.printStackTrace();
			throw e;
		} finally {
			quitQuietly(connection, statement, resultSet);
		}
	}

	public ArrayList<String> getTableList() {
		Connection connection = null;
		Statement statement = null;
		ResultSet resultSet = null;

		try {
			Class.forName(driver);

			connection = DriverManager.getConnection(dburl, username, password);
			DatabaseMetaData databaseMetaData = connection.getMetaData();
			String[] types = { "TABLE" };
			resultSet = databaseMetaData.getTables(connection.getCatalog(),
					null, null, types);

			ArrayList<ArrayList<String>> result = resultSetToString(resultSet,
					Integer.MAX_VALUE);
			result.remove(0);
			ArrayList<String> tableList = new ArrayList<String>();
			int TableNameIndex = 2;
			if (dbType == DbType.sqlserver || dbType == DbType.mysql)
				TableNameIndex = 2;
			/*
			 * if (dbType == DbType.oracle) TableNameIndex = 3;
			 */

			for (ArrayList<String> arrayList : result) {
				tableList.add(arrayList.get(TableNameIndex));
			}
			for (int i = 0; i < tableList.size(); i++) {
				tableList.set(i, tableList.get(i).toUpperCase());
			}
			return tableList;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		} finally {
			quitQuietly(connection, statement, resultSet);
		}
	}

	private static void quitQuietly(Connection connection, Statement statement,
			ResultSet resultSet) {
		if (resultSet != null)
			try {
				resultSet.close();
			} catch (Exception e) {
			}

		if (statement != null) {
			try {
				statement.close();
			} catch (Exception e) {
			}
		}
		if (connection != null) {
			try {
				connection.close();
			} catch (Exception e) {
			}
		}
	}

	int copyTable(String newDbName, String OldDbName)
			throws ClassNotFoundException, SQLException {
		String sql;
		if (dbType == DbType.sqlserver)
			sql = String.format("select * into %s from %s where 1=0",
					newDbName, OldDbName);
		else {
			sql = String.format(
					"create table %s as select * from %s where 1=2", newDbName,
					OldDbName);
		}
		return executeUpdate(sql);
	}

	enum ColType {
		String, Int, Float
	}

	int addColumn(String dbName, String colName, ColType type)
			throws ClassNotFoundException, SQLException {
		String typeName = null;
		switch (type) {
		case String:
			typeName = "varchar(2048)";
			break;
		case Int:
			typeName = "int";
			break;
		case Float:
			typeName = "float";
			break;
		default:
			return -1;
		}
		ArrayList<String> colList = getColumnList(dbName);
		if (colList.contains(colName))
			return -2;
		String sql = String.format("alter table %s add %s %s", dbName, colName,
				typeName);
		return executeUpdate(sql);
	}

	public RetValue<Integer, Integer, String> dupRemDeleteOr(String dbname,
			String[] dupcol) throws Exception {
		ArrayList<String> collist = getColumnList(dbname);
		for (String col : dupcol)
			if (!collist.contains(col))
				throw new Exception("column " + col
						+ " doesn't exist in database:" + dbname);

		Calendar calendar = Calendar.getInstance();
		String suffix = String.format("_%d%02d%d", calendar.get(Calendar.YEAR),
				calendar.get(Calendar.MONTH) + 1,
				calendar.get(Calendar.DAY_OF_MONTH));
		ArrayList<String> tableList = getTableList();
		for (int i = 0;; i++)
			if (!tableList.contains((dbname + suffix + "_" + i).toUpperCase())) {
				suffix = suffix + "_" + i;
				break;
			}
		String newDbname = dbname + suffix;
		copyTable(newDbname, dbname);

		HashMap<String, HashSet<String>> colDupMap = new HashMap<String, HashSet<String>>();
		for (String col : dupcol)
			colDupMap.put(col, new HashSet<String>());

		String sql = selectAll(dbname);

		Connection connection = null;
		Statement statement = null;
		ResultSet resultSet = null;
		int dup = 0;
		int rowCountBefore = 0;
		setTotal(getRowCount());
		setProgressed(0);
		try {
			Class.forName(driver);
			connection = DriverManager.getConnection(dburl, username, password);
			statement = connection.createStatement(ResultSet.TYPE_FORWARD_ONLY,
					ResultSet.CONCUR_UPDATABLE);
			resultSet = statement.executeQuery(sql);

			while (resultSet.next()) {
				rowCountBefore++;
				setProgressed(getProgressed() + 1);
				boolean isdup = false;
				for (int i = 0; i < dupcol.length; i++) {
					HashSet<String> colSet = (HashSet<String>) colDupMap
							.get(dupcol[i]);
					if (resultSet.getString(dupcol[i]) != null
							&& colSet.contains(resultSet.getString(dupcol[i])))
						isdup = true;
				}
				if (isdup) {
					dup++;
					// put it into backup table
					String insertSql = String.format("insert into %s values (",
							newDbname);
					for (int i = 1; i <= collist.size() - 1; i++) {
						if (isNUll(resultSet.getString(i)))
							insertSql = insertSql + "null,";
						else
							insertSql = insertSql + "'"
									+ resultSet.getString(i) + "',";
					}
					if (isNUll(resultSet.getString(collist.size())))
						insertSql = insertSql + "null)";
					else
						insertSql = insertSql + "'"
								+ resultSet.getString(collist.size()) + "')";

					executeUpdate(insertSql);
					// delete from original table
					resultSet.deleteRow();

				} else {
					for (int i = 0; i < dupcol.length; i++) {
						HashSet<String> colSet = (HashSet<String>) colDupMap
								.get(dupcol[i]);
						colSet.add(resultSet.getString(dupcol[i]));
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		} finally {
			quitQuietly(connection, statement, resultSet);
		}
		return new RetValue<Integer, Integer, String>(rowCountBefore, dup,
				newDbname);
	}

	public RetValue<Integer, Integer, String> dupRemDeleteAnd(String dbname,
			String[] dupcol) throws Exception {
		ArrayList<String> collist = getColumnList(dbname);
		for (String col : dupcol)
			if (!collist.contains(col))
				throw new Exception("column " + col
						+ " doesn't exist in database:" + dbname);

		Calendar calendar = Calendar.getInstance();
		String suffix = String.format("_%d%02d%d", calendar.get(Calendar.YEAR),
				calendar.get(Calendar.MONTH) + 1,
				calendar.get(Calendar.DAY_OF_MONTH));
		ArrayList<String> tableList = getTableList();
		for (int i = 0;; i++)
			if (!tableList.contains((dbname + suffix + "_" + i).toUpperCase())) {
				suffix = suffix + "_" + i;
				break;
			}

		String newDbname = dbname + suffix;
		copyTable(newDbname, dbname);

		/*
		 * HashMap<String, HashSet<String>> colDupMap = new HashMap<>(); for
		 * (String col : dupcol) colDupMap.put(col, new HashSet<String>());
		 */
		HashSet<String> aggregateColSet = new HashSet<String>();
		String sql = selectAll(dbname);

		Connection connection = null;
		Statement statement = null;
		ResultSet resultSet = null;
		int dup = 0;
		int rowCountBefore = 0;
		try {
			Class.forName(driver);
			connection = DriverManager.getConnection(dburl, username, password);
			// if (dbType == DbType.sqlserver || dbType == DbType.mysql)
			statement = connection.createStatement(ResultSet.TYPE_FORWARD_ONLY,
					ResultSet.CONCUR_UPDATABLE);
			// else
			// statement = connection.createStatement();

			resultSet = statement.executeQuery(sql);

			setTotal(getRowCount());
			setProgressed(0);
			while (resultSet.next()) {
				rowCountBefore++;
				setProgressed(getProgressed() + 1);
				boolean isdup = false;
				String aggregateKey = null;
				for (int i = 0; i < dupcol.length; i++) {
					String thiscol = resultSet.getString(dupcol[i]);
					if (thiscol == null)
						;
					else
						aggregateKey = aggregateKey + "__" + thiscol;
				}
				if (aggregateKey == null)
					;
				else
					isdup = aggregateColSet.contains(aggregateKey);

				if (isdup) {
					dup++;
					// put it into backup table
					String insertSql = String.format("insert into %s values (",
							newDbname);
					for (int i = 1; i <= collist.size() - 1; i++) {
						if (resultSet.getString(i) == null)
							insertSql = insertSql + resultSet.getString(i)
									+ ",";
						else
							insertSql = insertSql + "'"
									+ resultSet.getString(i) + "',";
					}
					if (resultSet.getString(collist.size()) == null)
						insertSql = insertSql
								+ resultSet.getString(collist.size()) + ")";
					else
						insertSql = insertSql + "'"
								+ resultSet.getString(collist.size()) + "')";

					executeUpdate(insertSql);
					// delete from original table
					resultSet.deleteRow();
					if (dbType == DbType.mysql)
						resultSet.previous();
				} else {
					aggregateColSet.add(aggregateKey);
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		} finally {
			quitQuietly(connection, statement, resultSet);
		}

		return new RetValue<Integer, Integer, String>(rowCountBefore, dup,
				newDbname);
	}

	final String delimiter = ",__,";
	final String nullToken = "THISFIELDISNULL";

	private String rowToStr(ResultSet resultSet) throws SQLException {
		String data = null;
		int nbcol = resultSet.getMetaData().getColumnCount();

		data = resultSet.getString(1);
		for (int i = 2; i <= nbcol; i++) {
			if (isNUll(resultSet.getString(i)))
				data = data + delimiter + nullToken;
			else {
				data = data + delimiter + resultSet.getString(i);
			}
		}
		return data;
	}

	private String ArrayToString(String[] a) {
		String data = null;
		int nbcol = a.length;
		data = a[0];
		for (int i = 1; i < nbcol; i++) {
			if (isNUll(a[i]))
				data = data + delimiter + nullToken;
			else {
				data = data + delimiter + a[i];
			}
		}
		return data;

	}

	private String[] strToRow(String string) {
		String[] row = string.split(delimiter, -1);
		for (int i = 0; i < row.length; i++) {
			if (row[i].equals(nullToken))
				row[i] = null;
		}
		return row;
	}

	private String merge(String a, String b) throws IllegalArgumentException {
		String[] aarray = strToRow(a);
		String[] barray = strToRow(b);
		if (aarray.length != barray.length)
			throw new IllegalArgumentException("illegal argument in merge:" + a
					+ " " + b);

		String[] newarray = new String[aarray.length];
		for (int i = 0; i < newarray.length; i++) {
			if (aarray[i] == null)
				newarray[i] = barray[i];
			else if (barray[i] == null) {
				newarray[i] = aarray[i];
			} else
				newarray[i] = aarray[i].length() > barray[i].length() ? aarray[i]
						: barray[i];
		}
		return ArrayToString(newarray);
	}

	private ArrayList<String> merge(ArrayList<ArrayList<String>> strs) {
		int size = strs.get(0).size();
		for (ArrayList<String> str : strs)
			if (str.size() != size)
				throw new IllegalArgumentException("illegal argument in merge:"
						+ strs);

		ArrayList<String> result = new ArrayList<String>();
		for (int i = 0; i < size; i++) {
			String value = strs.get(0).get(i);
			for (int j = 1; j < strs.size(); j++) {
				if (value == null
						|| (strs.get(j).get(i) != null && strs.get(j).get(i)
								.length() > value.length()))
					value = strs.get(j).get(i);
			}
			result.add(value);
		}
		return result;
	}

	private int clearTable(String dbname) throws ClassNotFoundException,
			SQLException {
		String sql = String.format("delete from %s where 1=1", dbname);
		return executeUpdate(sql);
	}

	public RetValue<Integer, Integer, String> dupRemMergeAnd(String dbname,
			String[] dupcol) throws Exception {
		ArrayList<String> collist = getColumnList(dbname);
		for (String col : dupcol)
			if (!collist.contains(col))
				throw new Exception("column " + col
						+ " doesn't exist in database:" + dbname);

		HashMap<String, String> aggregateKeyFullRowMap = new HashMap<String, String>();
		String sql = selectAll(dbname);

		Connection connection = null;
		Statement statement = null;
		ResultSet resultSet = null;
		int dup = 0;
		int rowCountBefore = 0;
		setTotal(getRowCount());
		setProgressed(0);
		try {
			Class.forName(driver);
			connection = DriverManager.getConnection(dburl, username, password);
			statement = connection.createStatement(ResultSet.TYPE_FORWARD_ONLY,
					ResultSet.CONCUR_UPDATABLE);
			resultSet = statement.executeQuery(sql);

			while (resultSet.next()) {
				rowCountBefore++;
				setProgressed(getProgressed() + 1);
				boolean isdup = false;
				String aggregateKey = null;
				for (int i = 0; i < dupcol.length; i++) {
					String thiscol = resultSet.getString(dupcol[i]);
					if (meaningLess(thiscol))
						;
					else
						aggregateKey = aggregateKey + delimiter + thiscol;
				}
				if (aggregateKey == null)
					;
				else
					isdup = aggregateKeyFullRowMap.containsKey(aggregateKey);

				if (isdup) {
					dup++;
					// update map
					// to be finished
					String oldRow = aggregateKeyFullRowMap.get(aggregateKey);
					String thisRwo = rowToStr(resultSet);
					String newRow = merge(oldRow, thisRwo);
					aggregateKeyFullRowMap.put(aggregateKey, newRow);
				} else {
					// put it into map
					String thisRow = rowToStr(resultSet);
					aggregateKeyFullRowMap.put(aggregateKey, thisRow);
				}
				// resultSet.deleteRow();
			}

			// clear original table
			clearTable(dbname);

			System.out.println("second step");
			setTotal(aggregateKeyFullRowMap.size());
			setProgressed(0);
			// write map to original table
			for (Map.Entry<String, String> entry : aggregateKeyFullRowMap
					.entrySet()) {
				setProgressed(getProgressed() + 1);
				// String insertSql = String.format("insert into %s values (",
				// dbname);
				String[] row = strToRow(entry.getValue());
				// for (int i = 0; i < row.length - 1; i++) {
				// if (row[i].length() == 0)
				// insertSql = insertSql + "null" + ",";
				// else
				// insertSql = insertSql + "'" + row[i] + "',";
				// }
				// if (row[row.length - 1].length() == 0)
				// insertSql = insertSql + "null" + ")";
				// else
				// insertSql = insertSql + "'" + row[row.length - 1] + "')";
				// executeUpdate(insertSql);
				ArrayList<String> rowArrayList = new ArrayList<String>();
				for (int i = 0; i < row.length; i++) {
					rowArrayList.add(row[i]);
				}
				insertIntoTable(dbname, rowArrayList);
			}
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		} finally {
			quitQuietly(connection, statement, resultSet);
		}
		return new RetValue<Integer, Integer, String>(rowCountBefore, dup,
				dbname);
	}

	private int insertIntoTable(String dbname, ArrayList<String> row)
			throws ClassNotFoundException, SQLException {
		String insertSql = String.format("insert into %s values (", dbname);
		for (int j = 0; j < row.size() - 1; j++) {
			if (isNUll(row.get(j)))
				insertSql = insertSql + "null,";
			else
				insertSql = insertSql + "'" + row.get(j) + "',";
		}
		if (isNUll(row.get(row.size() - 1)))
			insertSql = insertSql + "null)";
		else
			insertSql = insertSql + "'" + row.get(row.size() - 1) + "')";
		return executeUpdate(insertSql);
	}

	public RetValue<Integer, Integer, String> dupRemMergeOrDisjointSet(
			String dbname, String[] dupcol) throws Exception {
		ArrayList<String> collist = getColumnList(dbname);
		int[] colIndex = new int[collist.size()];

		for (int i = 0; i < dupcol.length; i++) {
			if (!collist.contains(dupcol[i]))
				throw new IllegalArgumentException("column " + dupcol[i]
						+ " doesn't exist in database:" + dbname);
			colIndex[i] = collist.indexOf(dupcol[i]);
		}
		String sql = selectAll(dbname);
		ArrayList<ArrayList<String>> table = executeQuery(sql,
				Integer.MAX_VALUE);
		// remove column name
		table.remove(0);

		int rowCountBefore = table.size();
		int[] father = new int[table.size()];
		for (int i = 0; i < father.length; i++)
			father[i] = i;

		HashMap<String, HashMap<String, Integer>> colDupRootMap = new HashMap<String, HashMap<String, Integer>>();
		for (int i = 0; i < dupcol.length; i++)
			colDupRootMap.put(dupcol[i], new HashMap<String, Integer>());

		setTotal(getRowCount());
		setProgressed(0);
		for (int i = 0; i < table.size(); i++) {
			setProgressed(getProgressed() + 1);
			for (int j = 0; j < dupcol.length; j++) {
				String col = dupcol[j];
				HashMap<String, Integer> colMap = colDupRootMap.get(col);
				int colindex = colIndex[j];
				String key = table.get(i).get(colindex);
				// !contains
				if (!colMap.containsKey(key)) {
					// put root of i to map
					int fa = i;
					while (fa != father[fa])
						fa = father[fa];
					colMap.put(key, fa);
					// path compress
					int x = i;
					int tmp;
					while (x != fa) {
						tmp = father[x];
						father[x] = fa;
						x = tmp;
					}
				} else {
					// merge
					int curRoot = colMap.get(key);
					while (father[curRoot] != curRoot)
						curRoot = father[curRoot];

					// union i and current root
					int fa = i;
					while (fa != father[fa])
						fa = father[fa];
					father[fa] = curRoot;
				}
			}
		}

		// put them into sets
		HashMap<Integer, HashSet<Integer>> setMap = new HashMap<Integer, HashSet<Integer>>();
		for (int i = 0; i < table.size(); i++) {
			int key = i;
			while (key != father[key])
				key = father[key];
			if (setMap.containsKey(key)) {
				HashSet<Integer> set = setMap.get(key);
				set.add(i);
			} else {
				HashSet<Integer> set = new HashSet<Integer>();
				set.add(i);
				setMap.put(key, set);
			}
		}

		setTotal(setMap.size());
		setProgressed(0);
		// clear original table
		clearTable(dbname);
		System.out.println(setMap.size());
		int dup = rowCountBefore - setMap.size();
		for (Map.Entry<Integer, HashSet<Integer>> entry : setMap.entrySet()) {

			setProgressed(getProgressed() + 1);

			HashSet<Integer> set = entry.getValue();
			ArrayList<ArrayList<String>> strs = new ArrayList<ArrayList<String>>();
			for (Integer index : set) {
				strs.add(table.get(index));
			}
			ArrayList<String> row = merge(strs);
			insertIntoTable(dbname, row);
		}
		return new RetValue<Integer, Integer, String>(rowCountBefore, dup,
				dbname);
	}

	/*
	 * added 2014/11/13 for real time process bar
	 */
	private final Object lock = new Object();
	private int progressed = 0;
	private int total = 0;

	private String message;

	public int getTotal() {
		synchronized (lock) {
			return total;
		}
	}

	private void setTotal(int total) {
		synchronized (lock) {
			this.total = total;
		}

	}

	private void setProgressed(int progressed) {
		synchronized (lock) {
			this.progressed = progressed;
		}
	}

	public int getProgressed() {

		synchronized (lock) {
			return progressed;

		}
	}

	public void setMessage(String message) {
		synchronized (lock) {
			this.message = message;
		}
	}

	public String getMessage() {
		synchronized (lock) {
			return message;

		}
	}

	public RetValue<Integer, Integer, String> updateProCityLongLat(
			String dbname, String[] usecol, boolean procity, boolean longlat)
			throws Exception {
		Connection connection = null;
		Statement statement = null;
		ResultSet resultSet = null;

		ArrayList<String> collist = getColumnList(dbname);
		for (int i = 0; i < collist.size(); i++) {
			collist.set(i, collist.get(i).toUpperCase());
		}
		for (int i = 0; i < usecol.length; i++) {
			if (!collist.contains(usecol[i].toUpperCase()))
				throw new IllegalArgumentException("column " + usecol[i]
						+ " doesn't exist in database:" + dbname);
		}

		if (procity) {
			if (!collist.contains("PROVINCE"))
				addColumn(dbname, "PROVINCE", ColType.String);
			if (!collist.contains("CITY"))
				addColumn(dbname, "CITY", ColType.String);
		}
		if (longlat) {
			if (!collist.contains("LONGITUDE"))
				addColumn(dbname, "LONGITUDE", ColType.String);
			if (!collist.contains("LATITUDE"))
				addColumn(dbname, "LATITUDE", ColType.String);
		}

		setTotal(getRowCount());
		setProgressed(0);

		int update = 0;
		String sql = selectAll(dbname);
		Class.forName(driver);
		connection = DriverManager.getConnection(dburl, username, password);
		statement = connection.createStatement(ResultSet.TYPE_FORWARD_ONLY,
				ResultSet.CONCUR_UPDATABLE);
		resultSet = statement.executeQuery(sql);

		while (resultSet.next()) {

			setProgressed(getProgressed() + 1);

			try {
				Thread.sleep(10);
				String loc = "";

				boolean Do = true;

				for (int i = 0; i < usecol.length; i++)
					if (usecol[i] != null
							&& resultSet.getString(usecol[i]) != null)
						loc = loc + resultSet.getString(usecol[i]);

				Location location = null;
				if (Do) {
					location = ExactLocation.getLocation(loc);
					if (location.city != null && location.province != null
							&& location.latitude != null
							&& location.longitude != null)
						update++;

				} else
					location = new Location(null, null, null, null);

				// update database
				if (procity) {
					resultSet.updateString("PROVINCE", location.province);
					resultSet.updateString("CITY", location.city);
				}
				if (longlat) {
					resultSet.updateString("LONGITUDE", location.longitude);
					resultSet.updateString("LATITUDE", location.latitude);
				}
				resultSet.updateRow();

			} catch (Exception e) {
				e.printStackTrace();
				continue;

			}
		}
		{
			quitQuietly(connection, statement, resultSet);
		}

		return new RetValue<Integer, Integer, String>(getRowCount(), update,
				dbname);

	}

	class Node {
		private int index;
		private int value;

		public Node(int i, int v) {
			index = i;
			value = v;
		}

	}

	// return rows with most NULLs(or empty string
	public ArrayList<ArrayList<String>> findDirty(String dbname, int n)
			throws Exception {
		ArrayList<ArrayList<String>> table = executeQuery(selectAll(dbname),
				Integer.MAX_VALUE);
		table.remove(0);
		n = n > table.size() ? table.size() : n;
		/*
		 * if (table.size() < n) throw new IllegalArgumentException(
		 * "n is larger than number of rows in table:" + dbname);
		 */

		ArrayList<Node> nbNull = new ArrayList<Node>();

		for (int i = 0; i < table.size(); i++) {
			Node node = new Node(i, 0);
			for (int j = 0; j < table.get(0).size(); j++)
				if (meaningLess(table.get(i).get(j)))
					node.value++;
			nbNull.add(node);
		}

		Collections.sort(nbNull, new Comparator<Node>() {
			@Override
			public int compare(Node o1, Node o2) {
				if (o1.value > o2.value)
					return -1;
				else if (o1.value == o2.value)
					return 0;
				else
					return 1;
			}
		});

		ArrayList<ArrayList<String>> result = new ArrayList<ArrayList<String>>();
		for (int i = 0; i < n; i++)
			result.add(table.get(nbNull.get(i).index));
		return result;
	}

	public ArrayList<Integer> findNullSum() throws ClassNotFoundException,
			SQLException {
		ArrayList<ArrayList<String>> table = executeQuery(selectAll(dbname),
				Integer.MAX_VALUE);

		int nbcol = table.get(0).size();

		table.remove(0);
		ArrayList<Integer> nullNum = new ArrayList<Integer>(nbcol);
		for (int i = 0; i <= nbcol; i++) {
			nullNum.add(0);
		}
		for (int i = 0; i < table.size(); i++) {
			int nullNumThis = 0;
			for (int j = 0; j < nbcol; j++) {
				if (meaningLess(table.get(i).get(j)))
					nullNumThis++;
			}
			nullNum.set(nullNumThis, nullNum.get(nullNumThis) + 1);
		}
		return nullNum;

	}

	/*
	 * delete rows whose have null values more than n, including row with n null
	 * values
	 */
	public void deleteNullMoreThan(String dbname, int n) throws SQLException,
			ClassNotFoundException {
		Connection connection = null;
		Statement statement = null;
		ResultSet resultSet = null;

		try {

			Class.forName(driver);

			connection = DriverManager.getConnection(dburl, username, password);
			statement = connection.createStatement(ResultSet.TYPE_FORWARD_ONLY,
					ResultSet.CONCUR_UPDATABLE);
			resultSet = statement.executeQuery(selectAll(dbname));
			int nbcol = getColumnList(dbname).size();
			while (resultSet.next()) {
				int nullsum = 0;
				for (int i = 1; i <= nbcol; i++) {
					if (meaningLess(resultSet.getString(i))) {
						nullsum++;
					}
				}
				if (nullsum >= n) {
					resultSet.deleteRow();
				}
			}
		} catch (SQLException e) {
			throw e;
		} finally {
			quitQuietly(connection, statement, resultSet);
		}

	}

	public int deleteRow(String dbname, ArrayList<String> row) throws Exception {
		ArrayList<String> columnList = getColumnList(dbname);
		if (columnList.size() != row.size())
			throw new IllegalArgumentException(
					"row size and number of column in table dismatch!");
		String sql = String.format("delete from %s where ", dbname);
		int ncol = columnList.size();
		for (int i = 0; i < ncol - 1; i++) {
			if (row.get(i) == null)
				sql = sql + columnList.get(i) + " is null and ";
			else
				sql = sql + columnList.get(i) + " = " + "'" + row.get(i) + "'"
						+ " and ";
		}
		if (row.get(ncol - 1) == null)
			sql = sql + columnList.get(ncol - 1) + " is null";
		else
			sql = sql + columnList.get(ncol - 1) + " = " + "'"
					+ row.get(ncol - 1) + "'";

		return executeUpdate(sql);
	}

	@Deprecated
	public void UpdateLX_ID() throws SQLException, ClassNotFoundException {
		Connection connection = null;
		Statement statement = null;
		ResultSet resultSet = null;
		Class.forName(driver);
		connection = DriverManager.getConnection(dburl, username, password);
		statement = connection.createStatement(ResultSet.TYPE_FORWARD_ONLY,
				ResultSet.CONCUR_UPDATABLE);
		ArrayList<String> tableList = getTableList();
		if (!tableList.contains("JGML_LXID".toUpperCase()))
			addColumn(dbname, "JGML_LXID", ColType.Int);

		resultSet = statement.executeQuery(selectAll(dbname));
		HashMap<Integer, Integer> map = new HashMap<Integer, Integer>();

		map.put(11469, 1);
		map.put(12597, 1);
		map.put(10967, 2);
		map.put(11523, 2);
		map.put(10940, 3);
		map.put(11470, 4);
		map.put(11471, 5);
		map.put(11472, 5);
		int i = 0;
		while (resultSet.next()) {
			System.out.println(i++);
			if (!isNUll(resultSet.getString("ChannelId"))) {
				int id = (int) Math.round(Double.parseDouble(resultSet
						.getString("ChannelId")));
				if (map.containsKey(id)) {
					resultSet.updateInt("JGML_LXID", map.get(id));
					resultSet.updateRow();
				}
			}
		}
	}

	public static void main(String[] args) throws Exception {
		SQLWrapper sqlWrapper = new SQLWrapper("sqlserver", "10.214.52.132",
				"1433", "TRSWCMV65", "wcmmetatablejgml", "canlian", "canlian",
				10);
		sqlWrapper.UpdateLX_ID();
		System.err.println(sqlWrapper.getRowCount());
	}
}