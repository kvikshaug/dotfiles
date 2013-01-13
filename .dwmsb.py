#!/usr/bin/python
from sh import amixer, free, ip, iwgetid, ifconfig, xsetroot, sensors, df, free
from sh import ErrorReturnCode_255
from datetime import datetime
import re, time

active_iface = None
previous_rx = None
previous_tx = None

def battery():
    with open('/sys/class/power_supply/BAT0/uevent') as f:
        lines = '\n'.join(f.readlines())
        status = re.findall('POWER_SUPPLY_STATUS=(.*)', lines)[0]
        if status == 'Full' or status == 'Unknown':
            return ''
        else:
            energy_now = float(re.findall('POWER_SUPPLY_ENERGY_NOW=(.*)', lines)[0])
            energy_full = float(re.findall('POWER_SUPPLY_ENERGY_FULL=(.*)', lines)[0])
            pst = round(energy_now / energy_full * 100)
            status_char = status[0].lower()
            return '%s%s | ' % (pst, status_char)

def audio():
    line = str(amixer("get", "Master")).split('\n')[4]
    if '[off]' in line:
        return 'M'
    else:
        vol = re.findall('\[(\d+%)\]', line)[0]
    return 'v%s' % vol

def mem_usage():
    mem = re.findall("Mem:\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)\s+(\d+)", str(free("-b")).split('\n')[1])[0]
    pst = ((int(mem[1]) - (int(mem[4]) + int(mem[5]))) / int(mem[0])) * 100
    return "m%.0d%%" % pst

def disk_usage():
    size, used = re.findall("/dev/sda4\s+(\d+)G\s+(\d+)", str(df("-h", ".")).split('\n')[1])[0]
    return "%s/%s" % (used, size)

def load_avg():
    with open('/proc/loadavg') as f:
        return f.readline()[:14]

def cpu_temp():
    return re.findall("\+(\d+)", str(sensors()).split('\n')[2])[0]

def net_usage():
    global previous_rx
    global previous_tx
    global active_iface
    if active_iface is None:
        previous_rx = None
        previous_tx = None
        return 'N/A'
    with open('/proc/net/dev') as f:
        relevant_line = [line for line in f.readlines() if line.strip().startswith(active_iface)]
        if len(relevant_line) == 0:
            # If we're suspended, or the active iface isn't in /proc/net/dev for some reason
            previous_rx = None
            previous_tx = None
            return 'N/A'
        relevant_line = relevant_line[0]

        cols = re.sub('\s+', ' ', relevant_line).strip().split(' ')
        current_rx = int(cols[1])
        current_tx = int(cols[9])
        if previous_rx is None and previous_tx is None:
            vals = {'rx': 0, 'tx': 0}
        else:
            vals = {
                'rx': ((current_rx - previous_rx) / 1024),
                'tx': ((current_tx - previous_tx) / 1024)}
        previous_rx = current_rx
        previous_tx = current_tx
        return "%03dRX/%03dTX" % (vals['rx'], vals['tx'])

def net_status():
    global active_iface
    active_iface = get_active_iface()
    if active_iface is not None:
        ip_address = re.findall("inet ([0-9\.]+)", str(ip.addr.show(active_iface)))[0]
    if active_iface == 'wlan0':
        essid = re.findall("ESSID:\"(.*?)\"", str(iwgetid()))[0]
        return "%s/%s" % (essid, ip_address)
    elif active_iface == 'eth0':
        return "eth0/%s" % (ip_address)
    else:
        return "N/A"

def get_active_iface():
    for iface in ['eth0', 'wlan0']:
        if str(ifconfig(iface)).find('inet ') != -1:
            return iface
    return None

def date():
    return datetime.strftime(datetime.now(), "%Y-%m-%d %W %H:%M")

while True:
    status_line = "%s%s | %s | %s | %s/%s | %s | %s | %s" % (battery(), audio(), mem_usage(), disk_usage(), load_avg(), cpu_temp(), net_usage(), net_status(), date())
    xsetroot('-name', status_line)
    time.sleep(1)

