﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ИсторияСохранения_ПриСозданииНаСервереПосле(Отказ, СтандартнаяОбработка)
	
	Если Параметры.ОбъектыПечати.Количество() > 0 Тогда
		ОбъектПечати = Параметры.ОбъектыПечати.ВыгрузитьЗначения()[0];
		КлючНастройки = Метаданные.НайтиПоТипу(ТипЗнч(ОбъектПечати)).Имя;
	Иначе
		КлючНастройки = "ОбщиеОбъекты";
	КонецЕсли;
	
	СтруктураПутей = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		ИмяНастройкиХраненияФайлов(),
		ИмяКлючНастройкиХраненияФайлов(),
		Неопределено);
		
	Если СтруктураПутей = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ СтруктураПутей.Свойство(КлючНастройки) Тогда
		Возврат;
	КонецЕсли;
	
	Элементы.ПапкаДляСохраненияФайлов.СписокВыбора.ЗагрузитьЗначения(СтруктураПутей[КлючНастройки]);
	
КонецПроцедуры

&НаКлиенте
Процедура ИсторияСохранения_ПриОткрытииПосле(Отказ)
	
	МассивСохраненныхПутей = Элементы.ПапкаДляСохраненияФайлов.СписокВыбора.ВыгрузитьЗначения();
	Если МассивСохраненныхПутей.Количество() = 0 Тогда
		ЗаполнитьИсториюВыбораПоУмолчанию();
	Иначе
		// Выберем последний сохраненный путь.
		ВыбраннаяПапка = МассивСохраненныхПутей[МассивСохраненныхПутей.Количество()-1];
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИсторияСохранения_СохранитьПеред(Команда)
	
	ИсторияСохранения_СохранитьПередНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция КоличествоОбъектовИстории()

	Возврат 5;

КонецФункции

&НаСервере
Процедура ИсторияСохранения_СохранитьПередНаСервере()
	
	СтруктураПутей = ОбщегоНазначения.ХранилищеОбщихНастроекЗагрузить(
		ИмяНастройкиХраненияФайлов(),
		ИмяКлючНастройкиХраненияФайлов(),
		Новый Структура);
		
	Если СтруктураПутей.Свойство(КлючНастройки) Тогда
		МассивПутей = СтруктураПутей[КлючНастройки];
	Иначе
		МассивПутей = Новый Массив;
	КонецЕсли;
	
	НайденныйПуть = МассивПутей.Найти(ВыбраннаяПапка);
	Если НайденныйПуть = Неопределено Тогда
		МассивПутей.Добавить(ВыбраннаяПапка);
		ОграничитьМассивПутей(МассивПутей);
		СтруктураПутей.Вставить(КлючНастройки, МассивПутей);
		
		ОбщегоНазначения.ХранилищеОбщихНастроекСохранить(
			ИмяНастройкиХраненияФайлов(),
			ИмяКлючНастройкиХраненияФайлов(),
			СтруктураПутей);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьИсториюВыбораПоУмолчанию()
	
	МассивЗначений = Элементы.ПапкаДляСохраненияФайлов.СписокВыбора.ВыгрузитьЗначения();
	МассивЗначений.Добавить(КаталогДокументов());
	Если НЕ ПустаяСтрока(ВыбраннаяПапка) Тогда
		МассивЗначений.Добавить(ВыбраннаяПапка);
	КонецЕсли;
	ВыбраннаяПапка = МассивЗначений[МассивЗначений.Количество()-1]; // Установим последний элемент.
	Элементы.ПапкаДляСохраненияФайлов.СписокВыбора.ЗагрузитьЗначения(МассивЗначений);
	
КонецПроцедуры

&НаСервере
Процедура ОграничитьМассивПутей(МассивПутей)
	
	КоличествоЭлементовВМассиве = МассивПутей.Количество();
	КоличествоОбъектовИстории = КоличествоОбъектовИстории();
	Если КоличествоЭлементовВМассиве <= КоличествоОбъектовИстории Тогда
		Возврат;
	КонецЕсли;
	
	ЭлементСКоторогоНачать = КоличествоЭлементовВМассиве - КоличествоОбъектовИстории;
	ОграниченныйМассивПутей = Новый Массив;
	
	Для Счетчик = 0 По КоличествоОбъектовИстории - 1 Цикл
		ОграниченныйМассивПутей.Добавить(МассивПутей[ЭлементСКоторогоНачать + Счетчик]);
	КонецЦикла;
	
	МассивПутей = ОграниченныйМассивПутей;
	
КонецПроцедуры

&НаСервере
Функция ИмяНастройкиХраненияФайлов()

	Возврат "Расширение_ХранениеПутейКФайлам";

КонецФункции

&НаСервере
Функция ИмяКлючНастройкиХраненияФайлов()

	Возврат "МассивПутей";

КонецФункции

#КонецОбласти