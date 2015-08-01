/**
 * Created by RasMisha on 07/30/2015
 */
public with sharing class PaginatorUtils {

	public static final String COMMA_SEPARATOR = ',';
	public static final String AND_SEPARATOR = ' AND ';

	public static final String SINGLE_QUOTE = '\'';
	public static final String LEFT_BRACKET = '(';
	public static final String RIGHT_BRACKET = ')';
	
	public static final Integer DOTS_IN_PAGINATION = -1;

	public static String join(Object[] objectsArray, String separator) {
		return join(objectsArray, separator, '', '');
	}
	
	public static String join(Object[] objectsArray, String separator, String itemPrefix, String itemPostfix) {
		String[] updatedArray = new String[] {};
		Boolean noItemPrefixAndPostfix = String.isBlank(itemPrefix) && String.isBlank(itemPostfix);

		if ((objectsArray instanceof String[]) && noItemPrefixAndPostfix) {
			return String.join(objectsArray, separator);
		}

		String stringItem;
		for (Object item : objectsArray) {
			if (item instanceof String) {
				stringItem = (String) item;
			} else {
				stringItem = String.valueOf(item);
			}
			
			stringItem = itemPrefix + stringItem + itemPostfix;

			updatedArray.add(stringItem);
		}

		return String.join(updatedArray, separator);
	}

	public static Integer[] getPaginationValues(Integer pagesNumber, Integer activePage) {
		Integer[] values = new Integer[] {};
		if (pagesNumber <= 6) {
			for (Integer value = 1; value <= pagesNumber; value++) {
				values.add(value);
			}
		} else {
			
			if (activePage > 3) {
				values.add(1);
				values.add(DOTS_IN_PAGINATION);
				if (activePage == pagesNumber) {
					values.add(activePage - 2);
				}
				values.add(activePage - 1);
				values.add(activePage);
			} else {

				for (Integer value = 1; value <= activePage; value++) {
					values.add(value);
				}
			}

			if (activePage < pagesNumber - 3) {
				values.add(activePage+1);
				if (activePage == 1) {
					values.add(activePage+2);
				}
				values.add(DOTS_IN_PAGINATION);
				values.add(pagesNumber);
			} else {
				for (Integer value = activePage + 1; value <= pagesNumber; value++) {
					values.add(value);
				}	
			}

		}
		return values;
	}

}