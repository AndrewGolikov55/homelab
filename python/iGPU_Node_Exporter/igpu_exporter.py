from prometheus_client import start_http_server, Metric, REGISTRY
import sys
import time
import subprocess

class DataCollector(object):
    # Данный метод сам собирает данные для Prometheus
    def __init__(self, endpoint):
        # Инициализация класса с дополнительной переменной
        self._endpoint = endpoint
    def collect(self):
        # Запуск команды в операционной системе и получение её вывода
        cmd = "/usr/bin/timeout -k 3 3 /usr/bin/intel_gpu_top -J"
        igpu = subprocess.run(cmd.split(), stdout=subprocess.PIPE, stderr=subprocess.PIPE).stdout.decode('utf-8')
  
        # Создание метрики "igpu_video_busy"
        metric = Metric('igpu_video_busy',' Video busy utilisation in %', 'summary')
        metric.add_sample('igpu_video_busy',
            # Извлечение значения нагрузки видеоядра
            value = igpu.split('engines')[3].split('"Video/0": {\n\t\t\t"busy": ')[1].split(',')[0], labels={})
        yield metric 

        metric = Metric('igpu_render_busy','Render busy utilisation in %', 'summary')
        metric.add_sample('igpu_render_busy',
            # Извлечение значения нагрузки рендера
            value = igpu.split('engines')[3].split('"Render/3D/0": {\n\t\t\t"busy": ')[1].split(',')[0], labels={})
        yield metric 

        metric = Metric('igpu_enhance_busy','Enhance busy utilisation in %', 'summary')
        metric.add_sample('igpu_enhance_busy',
            # Извлечение значения нагрузки метрики enhance
            value = igpu.split('engines')[3].split('"VideoEnhance/0": {\n\t\t\t"busy": ')[1].split(',')[0], labels={})
        yield metric 

        metric = Metric('igpu_power','Power utilisation in W', 'summary')
        metric.add_sample('igpu_power',
            # Извлечение значения затрат энергии (в ваттах)
            value = igpu.split('"power": {\n\t\t"value": ')[2].split(',')[0], labels={})
        yield metric 

if __name__ == '__main__':
    # При запуске скрипта начинается отслеживание заданного http порта
    start_http_server(int(sys.argv[1]))
    # Регистрация собирателя данных в REGISTRY
    REGISTRY.register(DataCollector(sys.argv[2]))

    # Бесконечный цикл, чтобы программа продолжала работать
    while True: time.sleep(1)