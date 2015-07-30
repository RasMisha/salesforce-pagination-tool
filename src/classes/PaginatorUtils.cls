/**
 * Created by RasMisha on 07/30/2015
 */
public with sharing class PaginatorUtils {

	public static final String COMMA_SEPARATOR = ',';
	
	public static final Integer DOTS_IN_PAGINATION = -1;
	
	public static String join(Object[] objectsArray, String separator, Boolean isString) {
		String[] updatedArray = new String[] {};

		if ((objectsArray instanceof String[]) && !isString) {
			return String.join(objectsArray, separator);
		}

		String stringItem;
		for (Object item : objectsArray) {
			if (item instanceof String) {
				stringItem = (String) item;
			} else {
				stringItem = String.valueOf(item);
			}

			if (isString) {
				stringItem = '\'' + stringItem + '\'';
			}

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