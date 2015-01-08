package tools.util;

public class Location {
	public String province = null;
	public String city = null;
	public String longitude;
	public String latitude;

	public Location(String province, String city, String longitude,
			String latitude) {
		this.province = province;
		this.city = city;
		this.longitude = longitude;
		this.latitude = latitude;
	}
}
