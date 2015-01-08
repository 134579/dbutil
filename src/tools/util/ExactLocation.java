package tools.util;

import java.io.IOException;
import java.io.InputStream;
import java.net.URL;

import javax.xml.parsers.*;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import tools.exception.MapApiException;

public class ExactLocation {

	private static String ak = "Kciy5yIFyHBTmxNup0TbIasc";

	public static Location getLocation(String loc) throws IOException,
			IOException, ParserConfigurationException, SAXException,
			MapApiException {
		URL url = new URL("http://api.map.baidu.com/geocoder/v2/?address="
				+ loc + "&output=xml&ak=" + ak);
		InputStream in = url.openStream();
		DocumentBuilder builder = DocumentBuilderFactory.newInstance()
				.newDocumentBuilder();
		Document document = builder.parse(in);

		Element GeocoderSearchResponse = (Element) document
				.getElementsByTagName("GeocoderSearchResponse").item(0);

		NodeList statusList = GeocoderSearchResponse
				.getElementsByTagName("status");
		Node statusNode = statusList.item(0);

		int status = Integer
				.parseInt(statusNode.getFirstChild().getNodeValue());

		if (status != 0) {
			// throw new MapApiException("1st step error, status = " + status);
			return new Location(null, null, null, null);
		}

		Element result = (Element) GeocoderSearchResponse.getElementsByTagName(
				"result").item(0);

		Element location = (Element) result.getElementsByTagName("location")
				.item(0);

		String latitude = location.getElementsByTagName("lat").item(0)
				.getFirstChild().getNodeValue();
		String longitude = location.getElementsByTagName("lng").item(0)
				.getFirstChild().getNodeValue();

		in.close();

		// from lat and lng to location
		url = new URL("http://api.map.baidu.com/geocoder/v2/?ak=" + ak
				+ "&location=" + latitude + "," + longitude + "&output=xml");
		in = url.openStream();
		builder = DocumentBuilderFactory.newInstance().newDocumentBuilder();
		document = builder.parse(in);

		GeocoderSearchResponse = (Element) document.getElementsByTagName(
				"GeocoderSearchResponse").item(0);

		statusNode = GeocoderSearchResponse.getElementsByTagName("status")
				.item(0);
		status = Integer.parseInt(statusNode.getFirstChild().getNodeValue());

		if (status != 0) {
			// throw new MapApiException("2nd step error, status = " + status);
			return new Location(null, null, null, null);
		}

		result = (Element) GeocoderSearchResponse
				.getElementsByTagName("result").item(0);

		Element addressComponent = (Element) result.getElementsByTagName(
				"addressComponent").item(0);

		String city = addressComponent.getElementsByTagName("city").item(0)
				.getFirstChild().getNodeValue();
		String province = addressComponent.getElementsByTagName("province")
				.item(0).getFirstChild().getNodeValue();
		return new Location(province, city, longitude, latitude);
	}
}
