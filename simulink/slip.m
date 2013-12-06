function slip = slip(whlSpeed, vehSpeed)
  if vehSpeed == 0
      if whlSpeed == 0
          slip = 0
      else
          slip == 1.0
      end
  else
      if vehSpeed > whlSpeed
        slip = 1 - (whlSpeed/vehSpeed)
      elseif whlSpeed > vehSpeed
        slip = 1 - (vehSpeed/whlSpeed)
      else
        slip = 0
      end
  end
end
