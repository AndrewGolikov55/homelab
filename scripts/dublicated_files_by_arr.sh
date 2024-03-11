#!/bin/bash

# Данный скрипт помогает в случаях когда:
# Radarr - https://github.com/Radarr/Radarr
# и
# Sonarr - https://github.com/Sonarr/Sonarr
# При импорте контента вместо создания жёсткой  
# ссылки производят копирование файла, что
# приводит к двойному потребению постоянной памяти.

# Начальное время
start=`date +%s`

# Определяем директории 
download_dir="/path/to/downloads/folder"
films_dir1="/path/to/films/folder"
serials_dir2="/path/to/serials/folder"

# Определяем файл для записи логов
log_file="./deleted_files.log"

# Декларация ассоциативного массива
declare -A films_files_map

# Заполняем ассоциативный массив именами файлов из директории Films и Serials
for films_dir in $films_dir1 $serials_dir2
do
  while IFS=  read -r -d $'\0'; do
      _file="$(basename "${REPLY}")"
      # Получаем inode файла
      _inode=$(stat -c %i "${REPLY}")
      films_files_map["${_file}"]="${REPLY} ${_inode}"
  done < <(find "$films_dir" -type f -print0)
done

# Проходим по всем файлам в директории Download
while IFS=  read -r -d $'\0'; do
    _file="$(basename "${REPLY}")"
    _inode=$(stat -c %i "${REPLY}")
 
    if [[ -n "${films_files_map[$_file]}" ]] && [[ "${films_files_map[$_file]##* }" != "$_inode" ]]; then
        echo "Найден скопированный файл в директории Films или Serials: ${films_files_map[$_file]}" | tee -a "$log_file"
        echo "Inode файла из Films или Serials: ${films_files_map[$_file]##* }" | tee -a "$log_file"
        echo "Тот же файл найден в директории Download: ${REPLY}" | tee -a "$log_file"
        echo "Inode файла из Download: $_inode" | tee -a "$log_file"
        echo "" | tee -a "$log_file"
        files_to_delete+=("${REPLY}")
    fi
done < <(find "$download_dir" -type f -print0)

# Если есть файлы для удаления...
if [[ ${#files_to_delete[@]} -gt 0 ]]; then
  # ...то спрашиваем пользователя, хочет ли он их удалить
  read -p "Хотите ли вы удалить исходные файлы из каталога Download? Y/N: " answer

  if [[ "$answer" == "Y" || "$answer" == "y" ]]; then
      total_size=0

      for file in "${files_to_delete[@]}"
      do
          file_size=$(du -b "$file" | cut -f1)
          total_size=$((total_size + file_size))
          rm "$file"
          echo "$file удалён" | tee -a "$log_file"
      done

      # Преобразуем байты в гигабайты (участвуют только целые числа)
      total_size_gb=$((total_size/1024/1024/1024))

      # Конечное время
      end=`date +%s`
      runtime=$((end-start))
      
      echo "" | tee -a "$log_file"
      echo "$(date) - Завершение работы скрипта" | tee -a "$log_file"
      echo "Выполнение заняло: $runtime секунд" | tee -a "$log_file"
      echo "Удалено файлов: ${#files_to_delete[@]}" | tee -a "$log_file"
      echo "Объем освободившегося места: $total_size_gb GB" | tee -a "$log_file"
  fi
fi
