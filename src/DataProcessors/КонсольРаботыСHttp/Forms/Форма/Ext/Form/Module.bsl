﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Схема = Элементы.Схема.СписокВыбора[0];
	ТипАвторизации = Элементы.ТипАвторизации.СписокВыбора[0];
КонецПроцедуры


&НаКлиенте
Процедура ВыполнитьЗапрос(Команда)
	ВыполнитьЗапросНаСервере();
	
	Элементы.ГруппаРазделы.ТекущаяСтраница = Элементы.РазделОтвет;
КонецПроцедуры

&НаСервере
Процедура ВыполнитьЗапросНаСервере()
	МножествоПараметровЗапроса = Новый Соответствие;
	МножествоЗаголовковЗапроса = Новый Соответствие;
	ДополнительныеПараметры = Новый Структура("Заголовки", МножествоЗаголовковЗапроса);
	
	Для Каждого Стр Из ПараметрыЗапроса.НайтиСтроки(Новый Структура("Активно", Истина)) Цикл
		Если МножественностьПараметровЗапроса Тогда
			ЗначениеПараметра = МножествоПараметровЗапроса.Получить(Стр.Ключ);
			Если ЗначениеПараметра = Неопределено Тогда
				МножествоПараметровЗапроса.Вставить(Стр.Ключ, Стр.Значение);
			Иначе
				Если ТипЗнч(ЗначениеПараметра) <> Тип("Массив") Тогда
					ИмеющеесяЗначениеПараметра = ЗначениеПараметра;
					
					ЗначениеПараметра = Новый Массив;
					ЗначениеПараметра.Добавить(ИмеющеесяЗначениеПараметра);
					
					МножествоПараметровЗапроса.Вставить(Стр.Ключ, ЗначениеПараметра);
				КонецЕсли;
				
				ЗначениеПараметра.Добавить(Стр.Значение);
			КонецЕсли;
		Иначе
			МножествоПараметровЗапроса.Вставить(Стр.Ключ, Стр.Значение);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого Стр Из ЗаголовкиЗапроса.НайтиСтроки(Новый Структура("Активно", Истина)) Цикл
		МножествоЗаголовковЗапроса.Вставить(Стр.Ключ, Стр.Значение);
	КонецЦикла;
	
	Если ТипАвторизации <> Элементы.ТипАвторизации.СписокВыбора[0].Значение Тогда
		ДополнительныеПараметры.Вставить(
			"Аутентификация",
			Новый Структура("Тип, Пользователь, Пароль", ТипАвторизации, ПользовательАвторизации, ПарольАвторизации)
		);
	КонецЕсли;
	
	ОтветHTTP = РаботаСHttp.Получить(ИдентификаторРесурса, МножествоПараметровЗапроса, ДополнительныеПараметры);
	КодСостояния = ОтветHTTP.КодСостояния;
	
	ЗаголовкиОтвета.Очистить();
	Для Каждого КЗ Из ОтветHTTP.Заголовки Цикл
		ЗаполнитьЗначенияСвойств(ЗаголовкиОтвета.Добавить(), КЗ);
	КонецЦикла;
	ЗаголовкиОтвета.Сортировать("Ключ");
	
	Ответ = ОтветHTTP.ПолучитьТелоКакСтроку();
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
	
	ПараметрыИдентификатора = Новый Массив;
	Для Каждого Стр Из ПараметрыЗапроса Цикл
		Если Стр.Активно Тогда
			ПараметрыИдентификатора.Добавить(Стр.Ключ + "=" + Стр.Значение);
		КонецЕсли;
	КонецЦикла;
	
	Если ПараметрыИдентификатора.Количество() > 0 Тогда
		НовыйИдентификатор = НовыйИдентификатор + "?" + СтрСоединить(ПараметрыИдентификатора, "&");
	КонецЕсли;
	
	ИдентификаторРесурса = НовыйИдентификатор;
КонецПроцедуры
#КонецОбласти
