# Práctica TDD para iOS

Los tests del data source se encuentran en el fuente *ControllerTests.m* y cubren los siguientes hechos:

- Si hay n divisas en el modelo, el dataSource devuelve n + 1 secciones. Esto está cubierto por los tests: *testThatTableHasTheNeededSections* y *testThatTableWithEmptyWalletHasOneSection*.

- Si hay n moneys en una divisa, el data source debe de devolver n + 1 celdas para esa sección. Esto está cubierto por los tests: *testThatTheNumberOfCellsInSectionIsNumberOfMoneysAtCurrency*, *testThatTheNumberOfCellsInLastSectionIsOne*, *testThatNumberOfCellsIsNumberOfMoneysPlusOne*.