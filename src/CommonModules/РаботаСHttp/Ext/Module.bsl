﻿
Функция ПозицииТокеновПеченья(Знач ОписаниеПеченья) Экспорт
	фРезультат = Новый Массив;
	
	КЧ = Новый КвалификаторыЧисла(10, 0, ДопустимыйЗнак.Неотрицательный);
	
	ОТЧ = Новый ОписаниеТипов("Число", КЧ);
	ОТС = Новый ОписаниеТипов("Строка", , Новый КвалификаторыСтроки(20, ДопустимаяДлина.Переменная));
	ОТЧН = Новый ОписаниеТипов("Null, Число", КЧ);
	
	ПозицииТокенов = Новый ТаблицаЗначений;
	ПозицииТокенов.Колонки.Добавить("Позиция",   ОТЧ);
	ПозицииТокенов.Колонки.Добавить("Токен",     ОТС);
	ПозицииТокенов.Колонки.Добавить("ТипТокена", ОТЧ);
	ПозицииТокенов.Колонки.Добавить("Смещение",  ОТЧ);
	ПозицииТокенов.Колонки.Добавить("КоличествоЗапятых", ОТЧН);
	
	ИменаКолонок = Новый Массив;
	Для Каждого Колонка Из ПозицииТокенов.Колонки Цикл
		ИменаКолонок.Добавить(Колонка.Имя);
	КонецЦикла;
	ИменаПолей = СтрСоединить(ИменаКолонок, ",");
	
	ДлинаОписания = СтрДлина(ОписаниеПеченья);
	Поиск = Новый Структура("НачальнаяПозиция, Позиция, Токен, ТипТокена, Смещение, КоличествоЗапятых", 1, 0, "", 0, 0, Неопределено);
	
	Для Каждого Токен Из РаботаСHttpПовтИсп.ТокеныПарсингаПеченья() Цикл
		ДлинаТокена = СтрДлина(Токен.Значение);
		
		Поиск.Токен             = Токен.Значение;
		Поиск.ТипТокена         = Токен.Тип;
		Поиск.НачальнаяПозиция  = 1;
		Поиск.Позиция           = СтрНайти(ОписаниеПеченья, Поиск.Токен, , Поиск.НачальнаяПозиция);
		Поиск.Смещение          = Токен.Смещение;
		Поиск.КоличествоЗапятых = Токен.КоличествоЗапятых;
		
		Пока Поиск.Позиция > 0 Цикл
			ЗаполнитьЗначенияСвойств(ПозицииТокенов.Добавить(), Поиск);
			
			Поиск.НачальнаяПозиция = Поиск.Позиция + ДлинаТокена;
			Если Поиск.НачальнаяПозиция > ДлинаОписания Тогда
				Прервать;
			КонецЕсли;
			
			Поиск.Позиция = СтрНайти(ОписаниеПеченья, Поиск.Токен, , Поиск.НачальнаяПозиция);
		КонецЦикла;
	КонецЦикла;

	ПозицииТокенов.Сортировать("Позиция");
	
	Для Каждого Стр Из ПозицииТокенов Цикл
		ПозицияТокена = Новый Структура(ИменаПолей);
		ЗаполнитьЗначенияСвойств(ПозицияТокена, Стр);
		фРезультат.Добавить(Новый ФиксированнаяСтруктура(ПозицияТокена));
	КонецЦикла;
	
	Возврат Новый ФиксированныйМассив(фРезультат);
КонецФункции

Функция ТекущаяУниверсальнаяДатаНаСервере() Экспорт
	Возврат ТекущаяУниверсальнаяДата();
КонецФункции
