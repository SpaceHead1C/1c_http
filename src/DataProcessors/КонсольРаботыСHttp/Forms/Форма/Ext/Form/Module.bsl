﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Схема = Элементы.Схема.СписокВыбора[0];
КонецПроцедуры


&НаКлиенте
Процедура ВыполнитьЗапрос(Команда)
	ВыполнитьЗапросНаСервере();
	
	Элементы.ГруппаРазделы.ТекущаяСтраница = Элементы.РазделОтвет;
КонецПроцедуры

&НаСервере
Процедура ВыполнитьЗапросНаСервере()
	МножествоПараметровЗапроса = Новый Соответствие;
	
	Для Каждого Стр Из ПараметрыЗапроса Цикл
		
	КонецЦикла;
	
	ОтветHTTP = РаботаСHttp.Получить(ИдентификаторРесурса, МножествоПараметровЗапроса);
	КодСостояния = ОтветHTTP.КодСостояния;
	
	ЗаголовкиОтвета.Очистить();
	Для Каждого КЗ Из ОтветHTTP.Заголовки Цикл
		ЗаполнитьЗначенияСвойств(ЗаголовкиОтвета.Добавить(), КЗ);
	КонецЦикла;
	
	Ответ = ОтветHTTP.ПолучитьТелоКакСтроку();
КонецПроцедуры

&НаКлиенте
Процедура ЗаголовкиОтветаПриАктивизацииСтроки(Элемент)
	ТекущиеДанные = Элементы.ЗаголовкиОтвета.ТекущиеДанные;
	ЗначениеЗаголовкаОтвета = ?(ТекущиеДанные = Неопределено, "", ТекущиеДанные.Значение);
КонецПроцедуры
