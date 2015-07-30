/**
 * Created by RasMisha on 07/30/2015
 */
@isTest
private class PaginatorTest {
	
	private static final Integer NUMBER_OF_ACCOUNTS = 205;

	@testSetup
	static void setupData() {
		Account[] accounts = new Account[] {};
		

		Account currentAccount = null;
		for (Integer index = 0; index < NUMBER_OF_ACCOUNTS; index++) {
			currentAccount = new Account();
			currentAccount.Name = 'Account Name ' + index;
			accounts.add(currentAccount);
		}

		Database.insert(accounts);
	}

	@isTest(seeAllData = false)
	static void testPaginatorInit() {
		Paginator paginator = new Paginator(Account.SObjectType);
		paginator.reloadRecords();
		System.assertEquals(30, paginator.getAllRecordsNumber());
		System.assertEquals(1, paginator.getStartIndexOnPage());
		System.assertEquals(25, paginator.getEndIndexOnPage());
		System.assertEquals(2, paginator.getPagesNumber());
	}
	
	@isTest(seeAllData = false)
	static void testPaginatorNextPage() {
		Paginator paginator = new Paginator(Account.SObjectType);
		paginator.reloadRecords();

		Test.startTest();
		paginator.nextPage();
		Test.stopTest();

		System.assertEquals(NUMBER_OF_ACCOUNTS, paginator.getAllRecordsNumber());
		System.assertEquals(26, paginator.getStartIndexOnPage());
		System.assertEquals(50, paginator.getEndIndexOnPage());
		System.assertEquals(2, paginator.getActivePage());
	}

	@isTest(seeAllData = false) 
	static void testPaginatorLastPage() {
		Paginator paginator = new Paginator(Account.SObjectType);
		paginator.reloadRecords();

		Test.startTest();
		paginator.lastPage();
		Test.stopTest();

		
	}
}