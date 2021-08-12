﻿
// SPDX-License-Identifier: Apache-2.0+

&НаКлиенте
Перем ТекущееИмяЗаголовка;


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ПоддержкаСжатогоОтвета = Истина;
	ИспользоватьСессию = Истина;
	ПоддержкаCookie = Истина;
	ПорогПеренаправлений = 10;
	
	Схема = Элементы.Схема.СписокВыбора[0];
	ТипАвторизации = Элементы.ТипАвторизации.СписокВыбора[0];
	ТипТелаЗапроса = Элементы.ТипТелаЗапроса.СписокВыбора[0].Значение;
	ТипТелаЗапросаКакЕсть = Элементы.ТипТелаЗапросаКакЕсть.СписокВыбора[0];
	ИдентификаторРесурса = "https://ya.ru";
	
	Дополнительно = Новый Структура("Сессия", Новый Структура("Печенье", Новый Соответствие));
КонецПроцедуры


#Область КОНСОЛЬ
&НаКлиенте
Процедура ВыполнитьЗапрос(Команда)
	ПЗ = МножествоПараметровЗапроса();
	ДП = ДополнительныеПараметрыЗапроса();
	
	// TODO: избавиться от дублирования кода 
	Если Схема = Элементы.Схема.СписокВыбора[0].Значение Тогда // GET
		ОтветHTTP = КлиентHTTPКлиентСервер.Получить(ИдентификаторРесурса, ПЗ, ДП);
	ИначеЕсли Схема = Элементы.Схема.СписокВыбора[1].Значение Тогда // POST
		ТипТелаЗапросаСписокВыбора = Элементы.ТипТелаЗапроса.СписокВыбора;
		Если ТипТелаЗапроса = ТипТелаЗапросаСписокВыбора[0].Значение Тогда // none
			ОтветHTTP = КлиентHTTPКлиентСервер.ОтправитьТекст(ИдентификаторРесурса, "", ДП, ПЗ);
		ИначеЕсли ТипТелаЗапроса = ТипТелаЗапросаСписокВыбора[1].Значение Тогда // form-data
			ОтветHTTP = КлиентHTTPКлиентСервер.ОтправитьДанныеФормы(ИдентификаторРесурса, ДанныеФормыТелаЗапроса(), ПараметрыОтправкиДанныхФормы(ДП), ПЗ);
		ИначеЕсли ТипТелаЗапроса = ТипТелаЗапросаСписокВыбора[2].Значение Тогда // raw
			ОтветHTTP = КлиентHTTPКлиентСервер.ОтправитьТекст(ИдентификаторРесурса, ТелоЗапросаТекст, ДП, ПЗ);
		ИначеЕсли ТипТелаЗапроса = ТипТелаЗапросаСписокВыбора[3].Значение Тогда // binary
			ОтветHTTP = КлиентHTTPКлиентСервер.ОтправитьФайл(ИдентификаторРесурса, Новый Файл(ТелоЗапросаФайл), ДП, ПЗ);
		КонецЕсли; 
	ИначеЕсли Схема = Элементы.Схема.СписокВыбора[2].Значение Тогда // PUT
		ТипТелаЗапросаСписокВыбора = Элементы.ТипТелаЗапроса.СписокВыбора;
		Если ТипТелаЗапроса = ТипТелаЗапросаСписокВыбора[0].Значение Тогда // none
			ОтветHTTP = КлиентHTTPКлиентСервер.ЗаписатьТекст(ИдентификаторРесурса, "", ДП, ПЗ);
		ИначеЕсли ТипТелаЗапроса = ТипТелаЗапросаСписокВыбора[2].Значение Тогда // raw
			ОтветHTTP = КлиентHTTPКлиентСервер.ЗаписатьТекст(ИдентификаторРесурса, ТелоЗапросаТекст, ДП, ПЗ);
		ИначеЕсли ТипТелаЗапроса = ТипТелаЗапросаСписокВыбора[3].Значение Тогда // binary
			ОтветHTTP = КлиентHTTPКлиентСервер.ЗаписатьФайл(ИдентификаторРесурса, Новый Файл(ТелоЗапросаФайл), ДП, ПЗ);
		Иначе 
			СообщитьПользователю(СтрШаблон("Тип тела запроса %1 не поддерживается для %2", ТипТелаЗапроса, Схема), "ТипТелаЗапроса");
			Возврат;
		КонецЕсли;
	ИначеЕсли Схема = Элементы.Схема.СписокВыбора[3].Значение Тогда // DELETE
		ТипТелаЗапросаСписокВыбора = Элементы.ТипТелаЗапроса.СписокВыбора;
		ТелоЗапроса = ?(
			ТипТелаЗапроса = ТипТелаЗапросаСписокВыбора[2].Значение, // raw
			ТелоЗапросаТекст,
			""
		);
		ОтветHTTP = КлиентHTTPКлиентСервер.Удалить(ИдентификаторРесурса, ТелоЗапроса, ДП, ПЗ);
	ИначеЕсли Схема = Элементы.Схема.СписокВыбора[4].Значение Тогда // HEAD
		ВызватьИсключение "Не реализовано";
	Иначе
		ВызватьИсключение "Неизвестная схема запроса";
	КонецЕсли;
	
	Если ИспользоватьСессию И ПоддержкаCookie Тогда
		КлиентHTTPКлиентСервер.СкопироватьПеченье(Дополнительно, ДП);
	КонецЕсли;
	
	КодСостояния = ОтветHTTP.КодСостояния;
	
	ЗаголовкиОтвета.Очистить();
	Для Каждого КЗ Из ОтветHTTP.Заголовки Цикл
		ЗаполнитьЗначенияСвойств(ЗаголовкиОтвета.Добавить(), КЗ);
	КонецЦикла;
	ЗаголовкиОтвета.Сортировать("Ключ");
	
	ИмяФайлаТела = ОтветHTTP.ИмяФайлаТела;
	
	КодировкаТелаОтвета = КлиентHTTPКлиентСервер.КодировкаИзЗаголовков(ОтветHTTP.Заголовки);
	Ответ = ?(
	    ТелоОтветаВФайл,
		"файл",
		?(
			КлиентHTTPПовтИсп.ТипыMIMEТекстовыхДанных().Получить(КлиентHTTPКлиентСервер.ТипMIMEИзЗаголовков(ОтветHTTP.Заголовки)) = Неопределено,
			"двоичные данные",
			ПолучитьСтрокуИзДвоичныхДанных(ОтветHTTP.Тело, ?(КодировкаТелаОтвета = Неопределено, КлиентHTTPПовтИсп.КодировкаПоУмолчанию(), КодировкаТелаОтвета))
		)
	);
	
	Элементы.ГруппаРазделы.ТекущаяСтраница = Элементы.РазделОтвет;
КонецПроцедуры

&НаКлиенте
Процедура ЗаголовкиОтветаПриАктивизацииСтроки(Элемент)
	ТекущиеДанные = Элементы.ЗаголовкиОтвета.ТекущиеДанные;
	ЗначениеЗаголовкаОтвета = ?(ТекущиеДанные = Неопределено, "", ТекущиеДанные.Значение);
КонецПроцедуры

&НаКлиенте
Процедура ТипАвторизацииПриИзменении(Элемент)
	Отображать = (ТипАвторизации <> Элементы.ТипАвторизации.СписокВыбора[0].Значение);
	
	Элементы.ПользовательАвторизации.Видимость = Отображать;
	Элементы.ГруппаПарольАвторизации.Видимость = Отображать;
	
	ИзменитьРежимОтображенияПароля(НЕ Отображать);
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьПарольАвторизации(Команда)
	ИзменитьРежимОтображенияПароля(НЕ Элементы.ПоказатьПарольАвторизации.Пометка);
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьРежимОтображенияПароля(Знач РежимПароля)
	Элементы.ПоказатьПарольАвторизации.Пометка = РежимПароля;
	Элементы.ПарольАвторизации.РежимПароля = НЕ Элементы.ПоказатьПарольАвторизации.Пометка;
КонецПроцедуры

&НаКлиенте
Процедура ИдентификаторРесурсаПриИзменении(Элемент)
	ЗаполнитьПараметрыПоИдентификаторуРесурса();
	РассчитатьПараметрыИдентификатораРесурса();
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНастройкиНажатие(Элемент)
	Элементы.ПрименитьНастройки.КнопкаПоУмолчанию = Истина;
	Элементы.Основная.ТекущаяСтраница = Элементы.СтраницаНастройки;
КонецПроцедуры

&НаКлиенте
Процедура СгенерироватьКодНажатие(Элемент)
	ОткрытьФорму("Обработка.КонсольКлиентаHTTP.Форма.РедакторТекстовогоПоля", Новый Структура("Текст", КодЗапросаКонсоли()), ЭтаФорма, , , , , РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьCookiesНажатие(Элемент)
	Оповещение = Новый ОписаниеОповещения("РедакторCookiesЗавершение", ЭтотОбъект, Дополнительно.Сессия);
	
	ОткрытьФорму("Обработка.КонсольКлиентаHTTP.Форма.РедакторCookies", Новый Структура("Печенье", Дополнительно.Сессия.Печенье), ЭтаФорма, , , , Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

#Область ПАРАМЕТРЫ_ЗАПРОСА
&НаКлиенте
Процедура ПараметрыЗапросаПриИзменении(Элемент)
	РассчитатьПараметрыИдентификатораРесурса();
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыЗапросаПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока И НЕ Копирование Тогда
		Элемент.ТекущиеДанные.Активно = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыЗапросаКлючОткрытие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элемент.Родитель.ТекущиеДанные;
	Оповещение = Новый ОписаниеОповещения("РедакторПараметраЗапросаЗавершение", ЭтотОбъект, "Ключ");
	
	ОткрытьФорму("Обработка.КонсольКлиентаHTTP.Форма.РедакторТекстовогоПоля", Новый Структура("Текст", ТекущиеДанные.Ключ), ЭтаФорма, , , , Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыЗапросаЗначениеОткрытие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элемент.Родитель.ТекущиеДанные;
	Оповещение = Новый ОписаниеОповещения("РедакторПараметраЗапросаЗавершение", ЭтотОбъект, "Значение");
	
	ОткрытьФорму("Обработка.КонсольКлиентаHTTP.Форма.РедакторТекстовогоПоля", Новый Структура("Текст", ТекущиеДанные.Значение), ЭтаФорма, , , , Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры
#КонецОбласти

#Область ЗАГОЛОВКИ_ЗАПРОСА
&НаКлиенте
Процедура ЗаголовкиЗапросаПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока И НЕ Копирование Тогда
		Элемент.ТекущиеДанные.Активно = Истина;
	КонецЕсли;
	
	ТекущееИмяЗаголовка = ?(НоваяСтрока, Неопределено, Элемент.ТекущиеДанные.Ключ);
КонецПроцедуры

&НаКлиенте
Процедура ЗаголовкиЗапросаПередОкончаниемРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования, Отказ)
	Если ОтменаРедактирования Тогда
		Если НЕ НоваяСтрока Тогда
			Элемент.ТекущиеДанные.Ключ = ТекущееИмяЗаголовка;
		КонецЕсли;
		
		Возврат;
	КонецЕсли;
	
	ИмяЗаголовка = ИсправленноеИмяЗаголовкаЗапроса(Элемент.ТекущиеДанные.Ключ);
	Если ТекущееИмяЗаголовка <> Неопределено И ИмяЗаголовка = ТекущееИмяЗаголовка Тогда
		Возврат;
	КонецЕсли;
	
	НайденныеСтроки = ЗаголовкиЗапроса.НайтиСтроки(Новый Структура("Ключ", ИмяЗаголовка));
	ПозицияТекущейСтрокиВНайденных = НайденныеСтроки.Найти(ЗаголовкиЗапроса.НайтиПоИдентификатору(Элемент.ТекущаяСтрока));
	Если ПозицияТекущейСтрокиВНайденных <> Неопределено Тогда
		НайденныеСтроки.Удалить(ПозицияТекущейСтрокиВНайденных);
	КонецЕсли;
	
	Отказ = (НайденныеСтроки.Количество() > 0);
	Если Отказ Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Введите уникальное имя заголовка (ограничение платформы 1С)";
		Сообщение.Сообщить();
		Возврат;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗаголовкиЗапросаКлючПриИзменении(Элемент)
	ТекущиеДанные = Элемент.Родитель.ТекущиеДанные;
	ТекущиеДанные.Ключ = ИсправленноеИмяЗаголовкаЗапроса(ТекущиеДанные.Ключ);
КонецПроцедуры

&НаКлиенте
Процедура ЗаголовкиЗапросаКлючОткрытие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элемент.Родитель.ТекущиеДанные;
	Оповещение = Новый ОписаниеОповещения("РедакторИмениЗаголовкаЗапросаЗавершение", ЭтотОбъект);
	
	ОткрытьФорму("Обработка.КонсольКлиентаHTTP.Форма.РедакторТекстовогоПоля", Новый Структура("Текст", ТекущиеДанные.Ключ), ЭтаФорма, , , , Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура ЗаголовкиЗапросаЗначениеОткрытие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элемент.Родитель.ТекущиеДанные;
	Оповещение = Новый ОписаниеОповещения("РедакторЗначенияЗаголовкаЗапросаЗавершение", ЭтотОбъект);
	
	ОткрытьФорму("Обработка.КонсольКлиентаHTTP.Форма.РедакторТекстовогоПоля", Новый Структура("Текст", ТекущиеДанные.Значение), ЭтаФорма, , , , Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры
#КонецОбласти

#Область ТЕЛО_ЗАПРОСА
&НаКлиенте
Процедура ТипТелаЗапросаПриИзменении(Элемент)
	ТипТелаЗапросаСписокВыбора = Элементы.ТипТелаЗапроса.СписокВыбора;
	Элементы.ГруппаТипыТелаЗапроса.Видимость = (ТипТелаЗапроса <> ТипТелаЗапросаСписокВыбора[0].Значение);
	Если ТипТелаЗапроса = ТипТелаЗапросаСписокВыбора[1].Значение Тогда // form-data
		Если ПустаяСтрока(Разделитель) Тогда
			РазделительОчистка(Неопределено, Ложь);
		КонецЕсли;
		
		Элементы.ГруппаТипыТелаЗапроса.ТекущаяСтраница = Элементы.ТипыТелаЗапросаДанныеФормы;
	ИначеЕсли ТипТелаЗапроса = ТипТелаЗапросаСписокВыбора[2].Значение Тогда // raw
		Элементы.ГруппаТипыТелаЗапроса.ТекущаяСтраница = Элементы.ТипыТелаЗапросаКакЕсть;
	ИначеЕсли ТипТелаЗапроса = ТипТелаЗапросаСписокВыбора[3].Значение Тогда // binary
		Элементы.ГруппаТипыТелаЗапроса.ТекущаяСтраница = Элементы.ТипыТелаЗапросаДвоичныеДанные;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура РазделительОчистка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Разделитель = XMLСтрока(Новый УникальныйИдентификатор);
КонецПроцедуры

#Область ДАННЫЕ_ФОРМЫ_ТЕЛО_ЗАПРОСА
&НаКлиенте
Процедура ДанныеФормыПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Если НоваяСтрока И НЕ Копирование Тогда
		ТекущиеДанные = Элемент.ТекущиеДанные;
		ТекущиеДанные.Тип     = Элемент.ПодчиненныеЭлементы.ДанныеФормыТип.СписокВыбора[0]; // Текст
		ТекущиеДанные.Активно = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДанныеФормыКлючОткрытие(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элемент.Родитель.ТекущиеДанные;
	Оповещение = Новый ОписаниеОповещения("РедакторПоляТелаЗапросаЗавершение", ЭтотОбъект, "Ключ");
	
	ОткрытьФорму("Обработка.КонсольКлиентаHTTP.Форма.РедакторТекстовогоПоля", Новый Структура("Текст", ТекущиеДанные.Ключ), ЭтаФорма, , , , Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура ДанныеФормыТипПриИзменении(Элемент)
	Элемент.Родитель.ТекущиеДанные.Значение = "";
КонецПроцедуры

&НаКлиенте
Процедура ДанныеФормыЗначениеНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элемент.Родитель.ТекущиеДанные;
	ДанныеФормыТипСписокВыбора = Элемент.Родитель.ПодчиненныеЭлементы.ДанныеФормыТип.СписокВыбора;
	
	Если ТекущиеДанные.Тип = ДанныеФормыТипСписокВыбора[1].Значение Тогда // Файл
		Оповещение = Новый ОписаниеОповещения("ВыборФайлаПоляФормыЗавершение", ЭтотОбъект, ТекущиеДанные);
		
		ПоказатьДиалогВыбораФайла(Оповещение, "Выбор файла для отправки");
	Иначе // Текст
		Оповещение = Новый ОписаниеОповещения("РедакторПоляТелаЗапросаЗавершение", ЭтотОбъект, "Значение");
		
		ОткрытьФорму("Обработка.КонсольКлиентаHTTP.Форма.РедакторТекстовогоПоля", Новый Структура("Текст", ТекущиеДанные.Значение), ЭтаФорма, , , , Оповещение, РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
КонецПроцедуры
#КонецОбласти

&НаКлиенте
Процедура ФайлТелаЗапросаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Оповещение = Новый ОписаниеОповещения("ВыборФайлаТелаЗапросаЗавершение", ЭтотОбъект);
	
	ПоказатьДиалогВыбораФайла(Оповещение, "Выбор файла для отправки");
КонецПроцедуры
#КонецОбласти
#КонецОбласти


#Область НАСТРОЙКИ
&НаКлиенте
Процедура ПрименитьНастройки(Команда)
	Элементы.ФормаВыполнить.КнопкаПоУмолчанию = Истина;
	Элементы.Основная.ТекущаяСтраница = Элементы.СтраницаКонсоль;
КонецПроцедуры

&НаКлиенте
Процедура ИмяФайлаТелаОтветаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	Оповещение = Новый ОписаниеОповещения("ВыборФайлаСохраненияТелаОтветаЗавершение", ЭтотОбъект);
		
	ПоказатьДиалогСохраненияФайла(Оповещение, "Выбор файла для сохранения");
КонецПроцедуры

&НаКлиенте
Процедура ИмяФайлаТелаОтветаПриИзменении(Элемент)
	ТелоОтветаВФайл = НЕ ПустаяСтрока(ИмяФайлаТелаОтвета);
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьСессиюПриИзменении(Элемент)
	Элементы.ГруппаНастройкиСессии.Доступность = ИспользоватьСессию;
	
	ПоддержкаCookieПриИзменении(Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура ПоддержкаCookieПриИзменении(Элемент)
	Элементы.ОткрытьCookies.Доступность = (ИспользоватьСессию И ПоддержкаCookie);
КонецПроцедуры
#КонецОбласти


#Область ВСПОМОГАТЕЛЬНЫЕ_ПРОЦЕДУРЫ_И_ФУНКЦИИ
&НаКлиенте
Процедура ЗаполнитьПараметрыПоИдентификаторуРесурса()
	// TODO: оформить в метод модуля
	ДлинаИдентификатораРесурса = СтрДлина(ИдентификаторРесурса);
	ПозицияНачалаПоиска = 7;
	
	Если СтрНачинаетсяС(ИдентификаторРесурса, "https://") Тогда
		ПозицияНачалаПоиска = 8;
	ИначеЕсли НЕ СтрНачинаетсяС(ИдентификаторРесурса, "http://") Тогда
		ВызватьИсключение "Не удалось разобрать URI";
	КонецЕсли;
	
	ЗначенияПараметров = Новый Соответствие;
	ЗначенияПараметровПоПорядку = Новый Массив;
	
	ПозицияНачалаСтрокиПараметров = СтрНайти(ИдентификаторРесурса, "?", , ПозицияНачалаПоиска);
	ПараметрыСтрока = ?(
		ПозицияНачалаСтрокиПараметров = 0,
		"",
		Прав(ИдентификаторРесурса, ДлинаИдентификатораРесурса - ПозицияНачалаСтрокиПараметров)
	);
	
	ПараметрыИдентификатора = СтрРазделить(ПараметрыСтрока, "&", Ложь);
	Для Каждого Параметр Из ПараметрыИдентификатора Цикл
		ПозицияРазделителя = СтрНайти(Параметр, "=");
		Если ПозицияРазделителя = 0 Тогда
			ПозицияРазделителя = СтрДлина(Параметр) + 1;
		КонецЕсли;
		
		ИмяПараметра = Лев(Параметр, ПозицияРазделителя - 1);
		Если ПустаяСтрока(ИмяПараметра) Тогда
			Продолжить;
		КонецЕсли;
		
		ЗначениеПараметра = Прав(Параметр, СтрДлина(Параметр) - ПозицияРазделителя);
		
		ЗначенияПараметра = ЗначенияПараметров.Получить(ИмяПараметра);
		Если ЗначенияПараметра = Неопределено Тогда
			ЗначенияПараметра = Новый Соответствие;
			ЗначенияПараметров.Вставить(ИмяПараметра, ЗначенияПараметра);
			Добавлять = Истина;
		Иначе
			Добавлять = (ЗначенияПараметра.Получить(ЗначениеПараметра) = Неопределено);
		КонецЕсли;
		
		Если Добавлять Тогда
			ЗначенияПараметра.Вставить(ЗначениеПараметра, Истина);
			ЗначенияПараметровПоПорядку.Добавить(Новый Структура("Ключ, Значение", ИмяПараметра, ЗначениеПараметра));
		КонецЕсли;
	КонецЦикла;
	
	СтрокиНаУдаление = Новый Массив;
	
	Для Каждого Стр Из ПараметрыЗапроса Цикл
		ЗначенияПараметра = ЗначенияПараметров.Получить(Стр.Ключ);
		Если ЗначенияПараметра = Неопределено Тогда
			Если Стр.Активно Тогда
				СтрокиНаУдаление.Добавить(Стр);
			КонецЕсли;
		Иначе
			Если ЗначенияПараметра.Получить(Стр.Значение) = Неопределено Тогда
				Если Стр.Активно Тогда
					СтрокиНаУдаление.Добавить(Стр);
				КонецЕсли;
			Иначе
				Стр.Активно = Истина;
				ЗначенияПараметра.Удалить(Стр.Значение);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого Стр Из СтрокиНаУдаление Цикл
		ПараметрыЗапроса.Удалить(Стр);
	КонецЦикла;
	
	Для Каждого ЗначениеПараметра Из ЗначенияПараметровПоПорядку Цикл
		ЗначенияПараметра = ЗначенияПараметров.Получить(ЗначениеПараметра.Ключ);
		Если ЗначенияПараметра = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		Если ЗначенияПараметра.Получить(ЗначениеПараметра.Значение) = Неопределено Тогда
			Продолжить;
		КонецЕсли;
		
		Стр = ПараметрыЗапроса.Добавить();
		Стр.Ключ     = ЗначениеПараметра.Ключ;
		Стр.Значение = ЗначениеПараметра.Значение;
		Стр.Активно  = Истина;
	КонецЦикла; 
КонецПроцедуры

&НаКлиенте
Процедура РассчитатьПараметрыИдентификатораРесурса()
	ДлинаИдентификатораРесурса = СтрДлина(ИдентификаторРесурса);
	ПозицияНачалаПоиска = 7;
	
	Если СтрНачинаетсяС(ИдентификаторРесурса, "https://") Тогда
		ПозицияНачалаПоиска = 8;
	ИначеЕсли НЕ СтрНачинаетсяС(ИдентификаторРесурса, "http://") Тогда
		ВызватьИсключение "Не удалось разобрать URI";
	КонецЕсли;
	
	ПозицияНачалаСтрокиПараметров = СтрНайти(ИдентификаторРесурса, "?", , ПозицияНачалаПоиска);
	
	НовыйИдентификатор = ?(
		ПозицияНачалаСтрокиПараметров = 0,
		ИдентификаторРесурса,
		Лев(ИдентификаторРесурса, ПозицияНачалаСтрокиПараметров - 1)
	);
	
	ПараметрыИдентификатора = КлиентHTTPКлиентСервер.НовыеПараметрыЗапроса();
	Для Каждого Стр Из ПараметрыЗапроса Цикл
		Если ПустаяСтрока(Стр.Ключ) Тогда
			Продолжить;
		КонецЕсли;
		
		КлиентHTTPКлиентСервер.ДобавитьПараметр(ПараметрыИдентификатора, Стр.Ключ, Стр.Значение);
	КонецЦикла;
	
	ИдентификаторРесурса = НовыйИдентификатор + КлиентHTTPКлиентСервер.ПараметрыЗапросаСтрокой(ПараметрыИдентификатора);
КонецПроцедуры

&НаКлиенте
Функция МножествоПараметровЗапроса()
	фРезультат = КлиентHTTPКлиентСервер.НовыеПараметрыЗапроса();
	
	Для Каждого Стр Из ПараметрыЗапроса Цикл
		Если НЕ Стр.Активно Тогда
			Продолжить;
		КонецЕсли;
		
		КлиентHTTPКлиентСервер.ДобавитьПараметр(фРезультат, Стр.Ключ, Стр.Значение);
	КонецЦикла;
	
	Возврат фРезультат;
КонецФункции

&НаКлиенте
Функция ДополнительныеПараметрыЗапроса()
	фРезультат = КлиентHTTPКлиентСервер.НовыеДополнительныеПараметры();
	
	УстановитьЗаголовкиЗапроса(фРезультат);
	
	ТипАвторизацииСписокВыбора = Элементы.ТипАвторизации.СписокВыбора;
	Если ТипАвторизации = ТипАвторизацииСписокВыбора[1].Значение Тогда // Basic
		КлиентHTTPКлиентСервер.УстановитьBasicАвторизацию(фРезультат, ПользовательАвторизации, ПарольАвторизации);
	ИначеЕсли ТипАвторизации = ТипАвторизацииСписокВыбора[2].Значение Тогда // NTLM
		КлиентHTTPКлиентСервер.УстановитьNTLMАвторизацию(фРезультат, ПользовательАвторизации, ПарольАвторизации);
	ИначеЕсли ТипАвторизации = ТипАвторизацииСписокВыбора[3].Значение Тогда // Digest
		КлиентHTTPКлиентСервер.УстановитьDigestАвторизацию(фРезультат, ПользовательАвторизации, ПарольАвторизации);
	КонецЕсли;
	
	Если ИспользоватьСессию Тогда
		КлиентHTTPКлиентСервер
			.ИспользоватьСессию(фРезультат)
			.УстановитьПорогПеренаправлений(фРезультат, ПорогПеренаправлений);
		
		Если ПоддержкаCookie Тогда
			КлиентHTTPКлиентСервер.СкопироватьПеченье(фРезультат, Дополнительно);
		КонецЕсли;
	КонецЕсли;
	
	Если ПоддержкаСжатогоОтвета Тогда
		КлиентHTTPКлиентСервер.УстановитьСжатиеОтветаGZIP(фРезультат);
	КонецЕсли;
	
	Если ТелоОтветаВФайл Тогда
		Если ПустаяСтрока(ИмяФайлаТелаОтвета) Тогда
			Элементы.Основная.ТекущаяСтраница = Элементы.СтраницаНастройки;
			ВызватьИсключение "Укажите путь к файлу ответа";
		КонецЕсли;
		
		КлиентHTTPКлиентСервер.УстановитьИмяВыходногоФайла(фРезультат, ИмяФайлаТелаОтвета);
	КонецЕсли;
	
	Возврат фРезультат;
КонецФункции

&НаКлиенте
Процедура УстановитьЗаголовкиЗапроса(Знач ДополнительныеПараметры)
	Для Каждого Стр Из ЗаголовкиЗапроса Цикл
		Если НЕ Стр.Активно Тогда
			Продолжить;
		КонецЕсли;
		
		КлиентHTTPКлиентСервер.УстановитьЗаголовок(ДополнительныеПараметры, Стр.Ключ, Стр.Значение);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Функция ДанныеФормыТелаЗапроса()
	фРезультат = КлиентHTTPКлиентСервер.НовыеПоляФормы();
	ТипыДанныхФормы = Элементы.ТелоЗапросаДанныеФормы.ПодчиненныеЭлементы.ДанныеФормыТип.СписокВыбора;
	
	Для Каждого Стр Из ТелоЗапросаДанныеФормы Цикл
		Если НЕ Стр.Активно Тогда
			Продолжить;
		КонецЕсли;
		
		Если Стр.Тип = ТипыДанныхФормы[0].Значение Тогда // Текст
			КлиентHTTPКлиентСервер.ДобавитьПолеФормыТекст(фРезультат, Стр.Ключ, Стр.Значение);
		Иначе // Файл
			Если ПустаяСтрока(Стр.Значение) Тогда
				Элементы.ГруппаРазделыЗапроса.ТекущаяСтраница = Элементы.РазделТелоЗапроса;
				Элементы.ГруппаРазделы.ТекущаяСтраница = Элементы.РазделЗапрос;
				
				ВызватьИсключение "Укажите выгружаемый файл в форме тела запроса";
			КонецЕсли;
			
			ФайлПоля = Новый Файл(Стр.Значение);
			Если НЕ ФайлПоля.Существует() Тогда
				Продолжить;
			КонецЕсли;
			
			ТипMIME = КлиентHTTPСлужебный.ТипMIMEРасширенияФайла(ФайлПоля.Расширение);
			
			КлиентHTTPКлиентСервер.ДобавитьПолеФормыФайл(фРезультат, Стр.Ключ, ФайлПоля, ФайлПоля.Имя, ТипMIME);
		КонецЕсли;
	КонецЦикла;
	
	Возврат фРезультат;
КонецФункции

&НаКлиенте
Функция ПараметрыОтправкиДанныхФормы(Знач ДополнительныеПараметры)
	фРезультат = КлиентHTTPКлиентСервер.КопияДополнительныхПараметров(ДополнительныеПараметры);
	
	КлиентHTTPКлиентСервер.УстановитьРазделительПолейФормы(фРезультат, Разделитель);
	
	Возврат фРезультат;
КонецФункции

&НаКлиенте
Процедура ПоказатьДиалогВыбораФайла(Знач Оповещение, Знач Заголовок = "Выбор файла")
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Диалог.Заголовок                   = Заголовок;
	Диалог.ПредварительныйПросмотр     = Ложь;
	Диалог.ПроверятьСуществованиеФайла = Истина;
	Диалог.МножественныйВыбор          = Ложь;
	Диалог.Показать(Оповещение);
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьДиалогСохраненияФайла(Знач Оповещение, Знач Заголовок = "Выбор файла")
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	Диалог.Заголовок                   = Заголовок;
	Диалог.ПредварительныйПросмотр     = Ложь;
	Диалог.ПроверятьСуществованиеФайла = Ложь;
	Диалог.МножественныйВыбор          = Ложь;
	Диалог.Показать(Оповещение);
КонецПроцедуры

&НаКлиенте
Процедура СообщитьПользователю(Знач Текст, Знач Поле)
	Сообщение = Новый СообщениеПользователю;
	Сообщение.Текст = Текст;
	Сообщение.Поле  = Поле;
	Сообщение.Сообщить();
КонецПроцедуры

&НаКлиенте
Функция ИсправленноеИмяЗаголовкаЗапроса(Знач Имя)
	фРезультат = Новый Массив;
	ДопустимыеСимволы = КлиентHTTPПовтИсп.ДопустимыеСимволыИмениЗаголовка();
	
	Для я = 1 По СтрДлина(Имя) Цикл
		СимволИмениЗаголовка = Сред(Имя, я, 1);
		
		фРезультат.Добавить(?(ДопустимыеСимволы.Получить(СимволИмениЗаголовка) = Неопределено, "-", СимволИмениЗаголовка));
	КонецЦикла;
	
	Возврат СтрСоединить(фРезультат);
КонецФункции

&НаКлиенте
Функция КодЗапросаКонсоли()
	ЧастиКода = Новый Массив;
	ЧастиСтрокиКода = Новый Массив;
	
	ЕстьДополнительныеПараметры = Ложь;
	ЕстьПараметрыЗапроса = Ложь;
	ЕстьПоляФормы = Ложь;
	ЕстьТекстТелаЗапроса = Ложь;
	ТребуетсяИмяФайлаТелаОтвета = Ложь;
	ТекстПолейФормы = Новый Массив;
	ФайлыПолейФормы = Новый Массив;
	
	// Переменная с идентификатором ресурса
	ПозицияПараметровЗапроса = СтрНайти(ИдентификаторРесурса, "?");
	
	ЧастиКода.Добавить(
		СтрШаблон(
			"ИдентификаторРесурса = ""%1"";",
			?(ПозицияПараметровЗапроса = 0, ИдентификаторРесурса, Лев(ИдентификаторРесурса, ПозицияПараметровЗапроса - 1))
		)
	);
	
	// Начало текучего интерфейса
	ЧастиКода.Добавить("Ответ = КлиентHTTPКлиентСервер");
	
	// Сессия
	Если ИспользоватьСессию Тогда
		ЧастиКода.Добавить("	.ИспользоватьСессию(ДополнительныеПараметры)");
		ЧастиКода.Добавить(СтрШаблон("	.УстановитьПорогПеренаправлений(ДополнительныеПараметры, %1)", XMLСтрока(ПорогПеренаправлений)));
		
		ЕстьДополнительныеПараметры = Истина;
	КонецЕсли;
	
	// Параметры URL HTTP-запроса
	Для Каждого Стр Из ПараметрыЗапроса Цикл
		Если НЕ Стр.Активно Тогда
			Продолжить;
		КонецЕсли;
		
		ЧастиКода.Добавить(СтрШаблон("	.ДобавитьПараметр(ПараметрыЗапроса, ""%1"", ""%2"")", СтрЗаменить(Стр.Ключ, """", """"""), СтрЗаменить(Стр.Значение, """", """""")));
		
		ЕстьПараметрыЗапроса = Истина;
	КонецЦикла;
	
	// Заголовки HTTP-запроса
	Для Каждого Стр Из ЗаголовкиЗапроса Цикл
		Если НЕ Стр.Активно Тогда
			Продолжить;
		КонецЕсли;
		
		ЧастиКода.Добавить(СтрШаблон("	.УстановитьЗаголовок(ДополнительныеПараметры, ""%1"", ""%2"")", Стр.Ключ, СтрЗаменить(Стр.Значение, """", """""")));
		
		ЕстьДополнительныеПараметры = Истина;
	КонецЦикла;
	
	// Сжатие ответа внешнего сервиса
	Если ПоддержкаСжатогоОтвета Тогда
		ЧастиКода.Добавить("	.УстановитьСжатиеОтветаGZIP(ДополнительныеПараметры)");
		
		ЕстьДополнительныеПараметры = Истина;
	КонецЕсли;
	
	// Авторизация
	ТипАвторизацииСписокВыбора = Элементы.ТипАвторизации.СписокВыбора;
	Если ТипАвторизации = ТипАвторизацииСписокВыбора[1].Значение Тогда // Basic
		ЧастиКода.Добавить(СтрШаблон("	.УстановитьBasicАвторизацию(ДополнительныеПараметры, ""%1"", ""%2"")", ПользовательАвторизации, ПарольАвторизации));
	ИначеЕсли ТипАвторизации = ТипАвторизацииСписокВыбора[2].Значение Тогда // NTLM
		ЧастиКода.Добавить(СтрШаблон("	.УстановитьNTLMАвторизацию(ДополнительныеПараметры, ""%1"", ""%2"")", ПользовательАвторизации, ПарольАвторизации));
	ИначеЕсли ТипАвторизации = ТипАвторизацииСписокВыбора[3].Значение Тогда // Digest
		ЧастиКода.Добавить(СтрШаблон("	.УстановитьDigestАвторизацию(ДополнительныеПараметры, ""%1"", ""%2"")", ПользовательАвторизации, ПарольАвторизации));
	КонецЕсли;
	
	Если ТелоОтветаВФайл Тогда
		ЕстьДополнительныеПараметры = Истина;
		ТребуетсяИмяФайлаТелаОтвета = ПустаяСтрока(ИмяФайлаТелаОтвета);
		
		ЧастиКода.Добавить(СтрШаблон("	.УстановитьИмяВыходногоФайла(ДополнительныеПараметры, %1)", ?(ТребуетсяИмяФайлаТелаОтвета, "ИмяФайлаТелаОтвета", СтрШаблон("""%1""", ИмяФайлаТелаОтвета))));
	КонецЕсли;
	
	// Метод выполнения HTTP-запроса
	Если Схема = Элементы.Схема.СписокВыбора[0].Значение Тогда // GET
		ЧастиКода.Добавить(СтрШаблон(
			"	.Получить(ИдентификаторРесурса%1%2%3);",
			?(ЕстьПараметрыЗапроса ИЛИ ЕстьДополнительныеПараметры, ", ", ""),
			?(ЕстьПараметрыЗапроса, "ПараметрыЗапроса", ""),
			?(ЕстьДополнительныеПараметры, ", ДополнительныеПараметры", "")
		));
	ИначеЕсли Схема = Элементы.Схема.СписокВыбора[1].Значение Тогда // POST
		ТипТелаЗапросаСписокВыбора = Элементы.ТипТелаЗапроса.СписокВыбора;
		Если ТипТелаЗапроса = ТипТелаЗапросаСписокВыбора[0].Значение Тогда // none
			ЧастиКода.Добавить(СтрШаблон(
				"	.ОтправитьТекст(ИдентификаторРесурса, """"%1%2%3);",
				?(ЕстьПараметрыЗапроса ИЛИ ЕстьДополнительныеПараметры, ", ", ""),
				?(ЕстьДополнительныеПараметры, "ДополнительныеПараметры", ""),
				?(ЕстьПараметрыЗапроса, ", ПараметрыЗапроса", "")
			));
		ИначеЕсли ТипТелаЗапроса = ТипТелаЗапросаСписокВыбора[1].Значение Тогда // form-data
			ЧастиКода.Добавить(СтрШаблон("	.УстановитьРазделительПолейФормы(ДополнительныеПараметры, ""%1"")", Разделитель));
			
			// Тело запроса
			НомерТекста = 0;
			НомерФайла = 0;
			ТипыДанныхФормы = Элементы.ТелоЗапросаДанныеФормы.ПодчиненныеЭлементы.ДанныеФормыТип.СписокВыбора;
			
			Для Каждого Стр Из ТелоЗапросаДанныеФормы Цикл
				Если НЕ Стр.Активно Тогда
					Продолжить;
				КонецЕсли;
				
				Если Стр.Тип = ТипыДанныхФормы[0].Значение Тогда // Текст
					НомерТекста = НомерТекста + 1;
					ИмяПеременной = "ТекстПоля" + XMLСтрока(НомерТекста);
					
					ТекстПолейФормы.Добавить(Новый Структура("ИмяПеременной, ЗначениеПеременной", ИмяПеременной, Стр.Значение));
					ЧастиКода.Добавить(СтрШаблон("	.ДобавитьПолеФормыТекст(ПоляФормы, ""%1"", %2)", Стр.Ключ, ИмяПеременной));
				Иначе // Файл
					Если ПустаяСтрока(Стр.Значение) Тогда
						Продолжить;
					КонецЕсли;
					
					НомерФайла = НомерФайла + 1;
					ИмяПеременной = "ФайлПоля" + XMLСтрока(НомерФайла);
					
					ФайлыПолейФормы.Добавить(Новый Структура("ИмяПеременной, Путь", ИмяПеременной, Стр.Значение));
					ЧастиКода.Добавить(
						СтрШаблон("	.ДобавитьПолеФормыФайл(ПоляФормы, ""%1"", %2, %3.Имя, КлиентHTTPСлужебный.ТипMIMEРасширенияФайла(%4.Расширение))" ,Стр.Ключ, ИмяПеременной, ИмяПеременной, ИмяПеременной)
					);
				КонецЕсли;
				
				ЕстьПоляФормы = Истина;
			КонецЦикла;
			ЧастиКода.Добавить(СтрШаблон(
				"	.ОтправитьДанныеФормы(ИдентификаторРесурса, %1%2%3%4);",
				?(ЕстьПоляФормы, "ПоляФормы", "КлиентHTTPКлиентСервер.НовыеПоляФормы()"),
				?(ЕстьПараметрыЗапроса ИЛИ ЕстьДополнительныеПараметры, ", ", ""),
				?(ЕстьДополнительныеПараметры, "ДополнительныеПараметры", ""),
				?(ЕстьПараметрыЗапроса, ", ПараметрыЗапроса", "")
			));
		ИначеЕсли ТипТелаЗапроса = ТипТелаЗапросаСписокВыбора[2].Значение Тогда // raw
			ЧастиКода.Добавить(СтрШаблон(
				"	.ОтправитьТекст(ИдентификаторРесурса, ТелоЗапросаТекст%1%2%3);",
				?(ЕстьПараметрыЗапроса ИЛИ ЕстьДополнительныеПараметры, ", ", ""),
				?(ЕстьДополнительныеПараметры, "ДополнительныеПараметры", ""),
				?(ЕстьПараметрыЗапроса, ", ПараметрыЗапроса", "")
			));
			
			ЕстьТекстТелаЗапроса = Истина;
		ИначеЕсли ТипТелаЗапроса = ТипТелаЗапросаСписокВыбора[3].Значение Тогда // binary
			Если ПустаяСтрока(ТелоЗапросаФайл) Тогда
				Элементы.ГруппаТипыТелаЗапроса.ТекущаяСтраница = Элементы.ТипыТелаЗапросаДвоичныеДанные;
				Элементы.ГруппаРазделыЗапроса.ТекущаяСтраница = Элементы.РазделТелоЗапроса;
				Элементы.ГруппаРазделы.ТекущаяСтраница = Элементы.РазделЗапрос;
				ВызватьИсключение "Укажите выгружаемый файл в теле запроса";
			КонецЕсли;
			
			ФайлыПолейФормы.Добавить(Новый Структура("ИмяПеременной, Путь", "ФайлТела", ТелоЗапросаФайл));
			ЧастиКода.Добавить(СтрШаблон(
				"	.ОтправитьФайл(ИдентификаторРесурса, ФайлТела%1%2%3);",
				?(ЕстьПараметрыЗапроса ИЛИ ЕстьДополнительныеПараметры, ", ", ""),
				?(ЕстьДополнительныеПараметры, "ДополнительныеПараметры", ""),
				?(ЕстьПараметрыЗапроса, ", ПараметрыЗапроса", "")
			));
		КонецЕсли; 
	ИначеЕсли Схема = Элементы.Схема.СписокВыбора[2].Значение Тогда // PUT
		ТипТелаЗапросаСписокВыбора = Элементы.ТипТелаЗапроса.СписокВыбора;
		Если ТипТелаЗапроса = ТипТелаЗапросаСписокВыбора[0].Значение Тогда // none
			ЧастиКода.Добавить(СтрШаблон(
				"	.ЗаписатьТекст(ИдентификаторРесурса, """"%1%2%3);",
				?(ЕстьПараметрыЗапроса ИЛИ ЕстьДополнительныеПараметры, ", ", ""),
				?(ЕстьДополнительныеПараметры, "ДополнительныеПараметры", ""),
				?(ЕстьПараметрыЗапроса, ", ПараметрыЗапроса", "")
			));
		ИначеЕсли ТипТелаЗапроса = ТипТелаЗапросаСписокВыбора[2].Значение Тогда // raw
			ЧастиКода.Добавить(СтрШаблон(
				"	.ЗаписатьТекст(ИдентификаторРесурса, ТелоЗапросаТекст%1%2%3);",
				?(ЕстьПараметрыЗапроса ИЛИ ЕстьДополнительныеПараметры, ", ", ""),
				?(ЕстьДополнительныеПараметры, "ДополнительныеПараметры", ""),
				?(ЕстьПараметрыЗапроса, ", ПараметрыЗапроса", "")
			));
			
			ЕстьТекстТелаЗапроса = Истина;
		ИначеЕсли ТипТелаЗапроса = ТипТелаЗапросаСписокВыбора[3].Значение Тогда // binary
			Если ПустаяСтрока(ТелоЗапросаФайл) Тогда
				Элементы.ГруппаТипыТелаЗапроса.ТекущаяСтраница = Элементы.ТипыТелаЗапросаДвоичныеДанные;
				Элементы.ГруппаРазделыЗапроса.ТекущаяСтраница = Элементы.РазделТелоЗапроса;
				Элементы.ГруппаРазделы.ТекущаяСтраница = Элементы.РазделЗапрос;
				ВызватьИсключение "Укажите выгружаемый файл в теле запроса";
			КонецЕсли;
			
			ФайлыПолейФормы.Добавить(Новый Структура("ИмяПеременной, Путь", "ФайлТела", ТелоЗапросаФайл));
			ЧастиКода.Добавить(СтрШаблон(
				"	.ЗаписатьФайл(ИдентификаторРесурса, ФайлТела%1%2%3);",
				?(ЕстьПараметрыЗапроса ИЛИ ЕстьДополнительныеПараметры, ", ", ""),
				?(ЕстьДополнительныеПараметры, "ДополнительныеПараметры", ""),
				?(ЕстьПараметрыЗапроса, ", ПараметрыЗапроса", "")
			));
		Иначе
			ВызватьИсключение СтрШаблон("Тип тела запроса %1 не поддерживается для %2", ТипТелаЗапроса, Схема);
		КонецЕсли;
	ИначеЕсли Схема = Элементы.Схема.СписокВыбора[3].Значение Тогда // DELETE
		ТипТелаЗапросаСписокВыбора = Элементы.ТипТелаЗапроса.СписокВыбора;
		Если ТипТелаЗапроса = ТипТелаЗапросаСписокВыбора[2].Значение Тогда // raw
			ЧастиКода.Добавить(СтрШаблон(
				"	.Удалить(ИдентификаторРесурса, ТелоЗапросаТекст%1%2%3);",
				?(ЕстьПараметрыЗапроса ИЛИ ЕстьДополнительныеПараметры, ", ", ""),
				?(ЕстьДополнительныеПараметры, "ДополнительныеПараметры", ""),
				?(ЕстьПараметрыЗапроса, ", ПараметрыЗапроса", "")
			));
			
			ЕстьТекстТелаЗапроса = Истина;
		Иначе
			ЧастиКода.Добавить(СтрШаблон(
				"	.Удалить(ИдентификаторРесурса%1%2%3);",
				?(ЕстьПараметрыЗапроса ИЛИ ЕстьДополнительныеПараметры, ", , ", ""),
				?(ЕстьДополнительныеПараметры, "ДополнительныеПараметры", ""),
				?(ЕстьПараметрыЗапроса, ", ПараметрыЗапроса", "")
			));
		КонецЕсли;
	ИначеЕсли Схема = Элементы.Схема.СписокВыбора[4].Значение Тогда // HEAD
		ЧастиКода.Добавить(СтрШаблон(
			"	.ПолучитьЗаголовки(ИдентификаторРесурса%1%2%3);",
			?(ЕстьПараметрыЗапроса ИЛИ ЕстьДополнительныеПараметры, ", ", ""),
			?(ЕстьПараметрыЗапроса, "ПараметрыЗапроса", ""),
			?(ЕстьДополнительныеПараметры, ", ДополнительныеПараметры", "")
		)); 
	КонецЕсли;
	
	ЧастиКода.Добавить(Символы.ПС + "Текст = ПолучитьСтрокуИзДвоичныхДанных(Ответ.Тело);"); 
	
	// Инициализация необходимых переменных
	Если ФайлыПолейФормы.Количество() > 0 Тогда
		Смещение = 0;
		Для Каждого ФайлПоляФормы Из ФайлыПолейФормы Цикл
			ЧастиКода.Вставить(1 + Смещение, СтрШаблон("%1 = Новый Файл(""%2"");", ФайлПоляФормы.ИмяПеременной, ФайлПоляФормы.Путь));
			
			Смещение = Смещение + 1;
		КонецЦикла;
		
		ЧастиКода.Вставить(1 + Смещение, "");
	КонецЕсли;
	
	Если ТекстПолейФормы.Количество() > 0 Тогда
		Смещение = 0;
		Для Каждого ТекстПоляФормы Из ТекстПолейФормы Цикл
			ЧастиКода.Вставить(1 + Смещение, ИнициализацияТекстовойПеременной(ТекстПоляФормы.ИмяПеременной, ТекстПоляФормы.ЗначениеПеременной));
			
			Смещение = Смещение + 1;
		КонецЦикла;
		
		ЧастиКода.Вставить(1 + Смещение, "");
	КонецЕсли;
	
	Если ЕстьПоляФормы Тогда
		ЧастиКода.Вставить(1, "ПоляФормы = КлиентHTTPКлиентСервер.НовыеПоляФормы();");
	КонецЕсли;
	
	Если ЕстьТекстТелаЗапроса Тогда
		ЧастиКода.Вставить(1, ИнициализацияТекстовойПеременной("ТелоЗапросаТекст", ТелоЗапросаТекст));
	КонецЕсли;
	
	Если ЕстьДополнительныеПараметры Тогда
		ЧастиКода.Вставить(1, "ДополнительныеПараметры = КлиентHTTPКлиентСервер.НовыеДополнительныеПараметры();");
	КонецЕсли;
	
	Если ЕстьПараметрыЗапроса Тогда
		ЧастиКода.Вставить(1, "ПараметрыЗапроса = КлиентHTTPКлиентСервер.НовыеПараметрыЗапроса();");
	КонецЕсли;
	
	Если ТребуетсяИмяФайлаТелаОтвета Тогда
		ЧастиКода.Вставить(1, "ИмяФайлаТелаОтвета = ПолучитьИмяВременногоФайла(""dat"");");
	КонецЕсли;
	
	ЧастиКода.Вставить(1 + ТребуетсяИмяФайлаТелаОтвета + ЕстьПараметрыЗапроса + ЕстьДополнительныеПараметры + ЕстьПоляФормы + ЕстьТекстТелаЗапроса, "");
	
	Возврат СтрСоединить(ЧастиКода, Символы.ПС);
КонецФункции

&НаКлиенте
Функция ИнициализацияТекстовойПеременной(Знач ИмяПеременной, Знач ЗначениеПеременной)
	Возврат СтрШаблон(
		"%1 = %2""%3"";",
		ИмяПеременной,
		?(
			СтрНайти(ЗначениеПеременной, Символы.ПС) > 0,
			"
			|	",
			""
		),
		СтрЗаменить(СтрЗаменить(ЗначениеПеременной, """", """"""), Символы.ПС, Символы.ПС + "	|")
	);
КонецФункции

#Область ОБРАТНЫЕ_ВЫЗОВЫ
&НаКлиенте
Процедура РедакторТекстовогоПоляЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если Результат <> Неопределено Тогда
		ДополнительныеПараметры = Результат;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура РедакторПараметраЗапросаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.ПараметрыЗапроса.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДвойнойПеренос = Символы.ПС + Символы.ПС;
	Пока СтрНайти(Результат, ДвойнойПеренос) > 0 Цикл
		Результат = СтрЗаменить(Результат, ДвойнойПеренос, Символы.ПС);
	КонецЦикла;
	
	ТекущиеДанные[ДополнительныеПараметры] = СтрЗаменить(Результат, Символы.ПС, " ");
	
	РассчитатьПараметрыИдентификатораРесурса();
КонецПроцедуры

&НаКлиенте
Процедура РедакторИмениЗаголовкаЗапросаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.ЗаголовкиЗапроса.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные.Ключ = ИсправленноеИмяЗаголовкаЗапроса(Результат);
КонецПроцедуры

&НаКлиенте
Процедура РедакторЗначенияЗаголовкаЗапросаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.ЗаголовкиЗапроса.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ДвойнойПеренос = Символы.ПС + Символы.ПС;
	Пока СтрНайти(Результат, ДвойнойПеренос) > 0 Цикл
		Результат = СтрЗаменить(Результат, ДвойнойПеренос, Символы.ПС);
	КонецЦикла;
	
	ТекущиеДанные.Значение = СтрЗаменить(Результат, Символы.ПС, " ");
КонецПроцедуры

&НаКлиенте
Процедура РедакторПоляТелаЗапросаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные = Элементы.ТелоЗапросаДанныеФормы.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат <> Неопределено Тогда
		ТекущиеДанные[ДополнительныеПараметры] = Результат;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВыборФайлаТелаЗапросаЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	Если ВыбранныеФайлы <> Неопределено Тогда
		ТелоЗапросаФайл = ВыбранныеФайлы[0];
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВыборФайлаСохраненияТелаОтветаЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	Если ВыбранныеФайлы <> Неопределено Тогда
		ИмяФайлаТелаОтвета = ВыбранныеФайлы[0];
	КонецЕсли;
	
	ИмяФайлаТелаОтветаПриИзменении(Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура ВыборФайлаПоляФормыЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	Если ВыбранныеФайлы <> Неопределено Тогда
		ДополнительныеПараметры.Значение = ВыбранныеФайлы[0];
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура РедакторCookiesЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если Результат <> Неопределено Тогда
		ДополнительныеПараметры.Печенье = Результат;
	КонецЕсли;
КонецПроцедуры
#КонецОбласти
#КонецОбласти
